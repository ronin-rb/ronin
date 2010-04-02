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
require 'ronin/platform/overlay'
require 'ronin/database'

module Ronin
  module UI
    module CommandLine
      module Commands
        #
        # The `ronin update` command.
        #
        class Update < Command

          desc 'Update all Overlays or just a specified Overlay'
          argument :name, :type => :string, :required => false

          #
          # Updates the previously installed or added Overlays.
          #
          def execute
            Database.setup

            unless name
              update_all_overlays!
            else
              update_overlay!
            end
          end

          protected

          #
          # Updates all Overlays.
          #
          def update_all_overlays!
            print_info "Updating Overlays ..."

            Platform::Overlay.update! do |overlay|
              print_cache_errors(overlay)
              print_info "Updating Overlay #{overlay} ..."
            end

            print_info "Overlays updated."
          end

          #
          # Updates a specific Overlay.
          #
          def update_overlay!
            begin
              overlay = Platform::Overlay.get(name)

            rescue Platform::OverlayNotFound => e
              print_error e.message
              exit -1
            end

            print_info "Updating Overlay #{overlay} ..."

            overlay.update!

            print_cache_errors(overlay)
            print_info "Overlay updated."
          end

          #
          # Print out any exceptions or validation errors encountered
          # when caching the files of the overlay.
          #
          # @param [Overlay] overlay
          #   The overlay that was updated.
          #
          def print_cache_errors(overlay)
            overlay.cached_files.each do |cached_file|
              if cached_file.cache_exception
                print_exception cached_file.cache_exception
              end

              if cached_file.cache_errors
                cached_file.cache_errors.each do |error|
                  print_error error
                end
              end
            end
          end

        end
      end
    end
  end
end
