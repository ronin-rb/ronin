#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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
#++
#

require 'ronin/static/static'

module Ronin
  module Static
    module Finders
      #
      # Passes all possible matching paths of the specified _path_
      # within the static directories to the specified _block_.
      #
      def static_paths(path,&block)
        Static.static_dirs.each do |dir|
          block.call(File.join(dir,path))
        end
      end

      #
      # Returns the first matching static path for the specified _path_.
      #
      def static_find(path)
        static_paths(path) do |full_path|
          return full_path if File.exists?(full_path)
        end

        return nil
      end

      #
      # Returns the first matching static file for the specified _path_.
      # If no matching static file can be found, +nil+ will be returned.
      #
      def find_static_file(path)
        static_paths(path) do |full_path|
          return full_path if File.file?(full_path)
        end

        return nil
      end

      #
      # Returns the first matching static directory for the specified
      # _path_. If no matching static directory can be found, +nil+ will be
      # returned.
      #
      def find_static_dir(path)
        static_paths(path) do |full_path|
          return full_path if File.directory?(full_path)
        end

        return nil
      end

      #
      # Returns the first matching static paths for the specified _pattern_.
      # If no matching static paths can be found, +nil+ will be returned.
      #
      def static_glob(pattern)
        static_paths(pattern) do |full_path|
          paths = Dir[full_path]

          return paths unless paths.empty?
        end

        return nil
      end

      #
      # Returns all matching static paths for the specified _path_.
      #
      def static_find_all(path)
        paths = []

        static_paths(path) do |full_path|
          paths << full_path if File.exists?(full_path)
        end

        return paths
      end

      #
      # Returns all matching static files forthe specified _path_.
      #
      def find_static_files(path)
        paths = []

        static_paths(path) do |full_path|
          paths << full_path if File.file?(full_path)
        end

        return paths
      end

      #
      # Returns all matching static directories for the specified _path_.
      #
      def find_static_dirs(path)
        paths = []

        static_paths(path) do |full_path|
          paths << full_path if File.directory?(full_path)
        end

        return paths
      end

      #
      # Returns all matching static paths for the specified _pattern_.
      #
      def static_glob_all(pattern)
        paths = []

        static_paths(pattern) do |full_path|
          paths += Dir[full_path]
        end

        return paths
      end
    end
  end
end
