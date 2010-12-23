#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/command_line/command'
require 'ronin/overlay'
require 'ronin/database'

module Ronin
  module UI
    module CommandLine
      module Commands
        #
        # The `ronin list` command.
        #
        class List < Command

          desc 'List all Overlays or a specific one'
          class_option :remote, :type => :boolean, :aliases => '-r'
          class_option :local, :type => :boolean, :aliases => '-l'
          argument :name, :type => :string, :required => false

          #
          # Lists the installed or added Overlays.
          #
          def execute
            Database.setup

            unless name
              list_all_overlays!
            else
              list_overlay!
            end
          end

          protected

          #
          # Lists all Overlays in the {Database}.
          #
          def list_all_overlays!
            query = {}

            if options.local?
              query[:domain] = Overlay::LOCAL_DOMAIN
            elsif options.remote?
              query[:domain.not] = Overlay::LOCAL_DOMAIN
            end

            # list all overlays by name
            Overlay.all(query).each do |overlay|
              if options.verbose?
                display_overlay(overlay)
              else
                indent { puts overlay }
              end
            end
          end

          #
          # Lists a specific Overlay.
          #
          def list_overlay!
            # find a specific overlay
            begin
              overlay = Overlay.find(name)
            rescue OverlayNotFound
              print_error "Could not find the Overlay #{name.dump}"
              return
            end

            display_overlay(overlay)
          end

          #
          # Prints an Overlay to the console.
          #
          # @param [Overlay] overlay
          #   The Overlay to display.
          #
          def display_overlay(overlay)
            print_title overlay.name

            indent do
              if overlay.installed?
                puts "Domain: #{overlay.domain}"
              else
                puts "Path: #{overlay.path}"
              end

              puts "SCM: #{overlay.scm}" if overlay.scm

              if options.verbose?
                putc "\n"

                if overlay.title
                  puts "Title: #{overlay.title}"
                end

                puts "URI: #{overlay.uri}" if overlay.uri

                if overlay.source
                  puts "Source URI: #{overlay.source}"
                end

                if overlay.website
                  puts "Website: #{overlay.website}"
                end

                putc "\n"

                unless overlay.cached_files.empty?
                  print_title 'Cached Files'

                  indent do
                    overlay.cached_files.each do |cached_file|
                      puts cached_file.path
                    end
                  end
                end

                if overlay.description
                  print_title "Description"

                  indent { puts "#{overlay.description}\n\n" }
                else
                  putc "\n"
                end
              else
                putc "\n"
              end
            end
          end

        end
      end
    end
  end
end
