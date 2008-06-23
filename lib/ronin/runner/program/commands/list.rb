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

require 'ronin/runner/program/command'
require 'ronin/cache/repository'

module Ronin
  module Runner
    module Program
      class ListCommand < Command

        command :list, :ls

        options('[NAME ...] [options]') do |opts|
          opts.options

          opts.arguments do
            opts.arg('NAME','Repository to display')
          end

          opts.summary('Display all or the specified repositories within the repository cache')
        end

        def arguments(*args)
          if args.empty?
            # list all repositories by name
            Cache::Repository.each do |repo|
              puts "  #{repo}"
            end
          else
            # list specified repositories
            args.each do |name|
              repo = Cache::Repository.get(name)

              puts "[ #{repo} ]\n\n"

              puts "  path: #{repo.path}" if options.settings.verbose
              puts "  media: #{repo.media}"
              puts "  uri: #{repo.uri}" if repo.uri

              if repo.description
                puts "  description:\n\n    #{repo.description}"
              end

              puts "\n"

              if options.settings.verbose
                puts "  extensions:\n\n"

                repo.each_extension do |ext|
                  puts "    #{ext}"
                end
              end
            end
          end
        end

      end
    end
  end
end
