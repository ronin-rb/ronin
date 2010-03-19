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
        class List < Command

          desc 'List all Overlays or a specific one'
          class_option :host, :type => :string, :aliaes => '-H'
          argument :name, :type => :string, :required => false

          def execute
            Database.setup

            unless name
              indent do
                # list all overlays by name
                Platform::Overlay.all.each { |overlay| puts overlay }
              end

              return
            end

            # find a specific overlay
            begin
              overlay = Platform::Overlay.get(name,options[:host])
            rescue Platform::OverlayNotFound
              print_error "Could not find the Overlay #{name.dump}"
              return
            end

            print_title overlay.name

            indent do
              if overlay.local?
                puts "Path: #{overlay.path}"
              end

              puts "SCM: #{overlay.scm}" if overlay.scm

              if overlay.host
                puts "Host: #{overlay.host}"
              end

              if options.verbose?
                putc "\n"

                if overlay.title
                  puts "Title: #{overlay.title}"
                end

                puts "URI: #{overlay.uri}" if overlay.uri

                if overlay.source
                  puts "Source URI: #{overlay.source}"
                end

                if overlay.source_view
                  puts "Source View: #{overlay.source_view}"
                end

                if overlay.website
                  puts "Website: #{overlay.website}"
                end

                unless overlay.extensions.empty?
                  print_array(overlay.extensions, :title => 'Extensions')
                end

                if overlay.description
                  puts "Description:\n\n"
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
