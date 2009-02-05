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

require 'ronin/ui/command_line/command'
require 'ronin/platform/overlay'

module Ronin
  module UI
    module CommandLine
      class ListCommand < Command

        command :list, :ls

        def initialize
          @cache = nil
          @verbose = false

          super
        end

        def define_options(opts)
          opts.usage = '[NAME ...] [options]'

          opts.options do
            opts.on('-C','--cache DIR','Specify an alternate overlay cache') do |dir|
              @cache = dir
            end

            opts.on('-v','--verbose','Enable verbose output') do
              @verbose = true
            end
          end

          opts.arguments(
            'NAME' => 'Overlay to display'
          )

          opts.summary('Display all or the specified repositories within the Overlay cache')
        end

        def arguments(*args)
          Platform.load_overlays(@cache) if @cache

          if args.empty?
            # list all overlays by name
            Platform.overlays.each_overlay do |overlay|
              puts "  #{overlay}"
            end

            return
          end

          # list specified overlays
          args.each do |name|
            overlay = Platform.overlays.get(name)

            puts "[ #{overlay.name} ]\n\n"

            puts "  Path: #{overlay.path}"
            puts "  Media: #{overlay.media}" if overlay.media
            puts "  URI: #{overlay.uri}" if overlay.uri

            if @verbose
              if overlay.source
                puts "  Source URI: #{overlay.source}"
              end

              if overlay.source_view
                puts "  Source View: #{overlay.source_view}"
              end

              if overlay.website
                puts "  Website: #{overlay.website}"
              end

              unless overlay.extensions.empty?
                puts "  Extensions:\n\n"
                overlay.each_extension { |ext| puts "    #{ext}" }
              end

              if overlay.description
                puts "  Description:\n\n    #{overlay.description}\n\n"
              else
                puts "\n"
              end
            else
              puts "\n"
            end
          end
        end

      end
    end
  end
end
