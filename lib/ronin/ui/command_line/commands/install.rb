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
      class InstallCommand < Command

        command :install

        def initialize
          @cache = nil
          @media = nil

          super
        end

        def define_options(opts)
          opts.usage = 'URI [options]'

          opts.options do
            opts.on('-C','--cache DIR','Specify an alternate overlay cache') do |dir|
              @cache = dir
            end

            opts.on('-m','--media [MEDIA]','Spedify the media-type of the overlay') do |media|
              @media = media
            end
          end

          opts.arguments(
            'URI' => 'The URI of the overlay to install'
          )

          opts.summary('Installs the overlay located at the specified URI')
        end

        def arguments(args)
          unless args.length == 1
            fail('only one overlay URI maybe specified')
          end

          uri = args.first

          Platform.load_overlays(@cache) if @cache

          Platform.install(:uri => uri, :media => @media) do |overlay|
            puts "Overlay #{overlay.name.dump} has been installed."
          end
        end

      end
    end
  end
end
