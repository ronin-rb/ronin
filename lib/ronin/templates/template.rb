#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/static/finders'

module Ronin
  module Templates
    module Template
      include Static::Finders

      protected

      #
      # A stack of directories to search for other templates within.
      #
      # @return [Array] The stack of directory paths.
      #
      # @since 0.3.0
      #
      def template_dirs
        @template_dirs ||= []
      end

      #
      # The first path in +template_dirs+, that will be used to search for
      # other templates in.
      #
      # @return [String, nil] Returns the first path in template_dirs, or
      #                       +nil+ if template_dirs is empty.
      #
      # @since 0.3.0
      #
      def template_dir
        template_dirs.first
      end

      #
      # Finds the template within the +template_dir+ or uses
      # Static::Finders#find_static_file to search through all
      # +static+ directories for the template.
      #
      # @param [String] sub_path The relative path of the template to find.
      #
      # @return [String, nil] Returns the absolute path to the template,
      #                       or +nil+ if the template could not be found.
      #
      # @example
      #   find_template 'sub/path/template.erb'
      #
      # @since 0.3.0
      #
      def find_template(sub_path)
        sub_path = sub_path.to_s

        if template_dir
          path = File.expand_path(File.join(template_dir,sub_path))

          return path if File.file?(path)
        end

        return find_static_file(sub_path)
      end

      #
      # Finds the template, pushing the directory that the template resides
      # within to +template_dirs+, calls the given _block_ and then pops
      # the directory off of +template_dirs+.
      #
      # @param [String] sub_path The relative path of the template to find.
      #
      # @yield [path] The block to be called after the directory of the
      #               template has been pushed onto +template_dirs+. After
      #               the block has returned, the directory will be popped
      #               off of +template_dirs+.
      # @yieldparam [String] path The absolute path of the template.
      #
      # @return [Object] Result of the given block.
      # @raise [RuntimeError] The template was not found.
      #
      # @example
      #   enter_template('sub/path/template.erb') do |path|
      #     # do stuff with the full path
      #   end
      #
      # @since 0.3.0
      #
      def enter_template(sub_path,&block)
        sub_path = sub_path.to_s

        unless (path = find_template(sub_path))
          raise(RuntimeError,"could not find template #{sub_path.dump}",caller)
        end

        template_dirs.unshift(File.dirname(path))

        result = block.call(path)

        template_dirs.shift
        return result
      end
    end
  end
end
