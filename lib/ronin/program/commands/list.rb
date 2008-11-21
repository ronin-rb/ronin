#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/program/command'
require 'ronin/cache/overlay'

module Ronin
  module Program
    class ListCommand < Command

      command :list, :ls

      def define_options(opts)
        opts.usage = '[NAME ...] [options]'

        opts.options do |opts|
          opts.on('-v','--verbose','Enable verbose output') do
            @verbose = true
          end
        end

        opts.arguments {
          'NAME' => 'Overlay to display'
        }

        opts.summary('Display all or the specified repositories within the repository cache')
      end

      def arguments(*args)
        if args.empty?
          # list all repositories by name
          Cache::Overlay.each { |repo| puts "  #{repo}" }
          return
        end

        # list specified repositories
        args.each do |name|
          repo = Cache::Overlay.get(name)

          puts "[ #{repo} ]\n\n"

          puts "  path: #{repo.path}" if @verbose
          puts "  media: #{repo.media}"
          puts "  uri: #{repo.uri}" if repo.uri

          if repo.description
            puts "  description:\n\n    #{repo.description}"
          end

          puts "\n"

          if @verbose
            puts "  extensions:\n\n"
            repo.each_extension { |ext| puts "    #{ext}" }
          end
        end
      end

    end
  end
end
