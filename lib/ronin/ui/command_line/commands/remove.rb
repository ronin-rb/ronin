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
require 'ronin/platform'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Remove < Command

          desc 'Remove the specified Overlay'
          class_option :cache, :type => :string, :aliases => '-C'
          argument :name, :type => :string

          def execute
            if options[:cache]
              Platform.load_overlays(options[:cache])
            end

            begin
              Platform.remove(name) do |overlay|
                print_info "Removing Overlay #{overlay.name.dump} ..."
              end
            rescue Platform::OverlayNotFound => e
              print_error e.message
              exit -1
            end
          end

        end
      end
    end
  end
end
