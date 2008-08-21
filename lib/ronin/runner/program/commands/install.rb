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
require 'ronin/cache/overlay'

module Ronin
  module Runner
    module Program
      class InstallCommand < Command

        command :install

        options('URI [options]') do |opts|
          opts.settings.media = nil
          opts.settings.uri = nil

          opts.options do
            opts.on('-m','--media [MEDIA]','Spedify the media-type of the repository') do |media|
              options.settings.media = media
            end
          end

          opts.arguments do
            opts.arg('URI','The URI of the repository to install')
          end

          opts.summary('Installs the repository located at the specified URI')
        end

        def arguments(args)
          unless args.length==1
            fail('install: only one repository URI maybe specified')
          end

          Cache::Overlay.save_cache do
            Cache::Overlay.install(:uri => args.first, :media => options.settings.media) do |repo|
              puts "Overlay #{repo} has been installed."
            end
          end
        end
      end
    end
  end
end
