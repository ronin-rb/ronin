#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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

require 'ronin/runner/program/program'
require 'ronin/cache/repository'

module Ronin
  module Runner
    module Program
      Program.command(:add) do |argv|
        options = Options.command('ronin','add','PATH [options]') do |options|
          options.media = :local
          options.uri = nil

          options.specific do
            options.on('-m','--media','Spedify the media-type of the repository') do |media|
              options.media = media
            end

            options.on('-U','--uri','Specify the source URI of the repository') do |uri|
              options.uri = uri
            end
          end

          options.common do
            options.on_help
          end

          options.arguments do
            options.arg('PATH','Add the repository located at the specified PATH')
          end

          options.summary('Add a local repository located at the specified PATH to the repository cache')

          options.defaults('--media local')
        end

        options.parse(argv) do |args|
          unless args.length==1
            Program.fail('add: only one repository path maybe specified')
          end

          path = args.first

          Cache::Repository.save_cache do
            Cache::Repository.add(path,options.media,options.uri) do |repo|
              puts "Repository #{repo} added."
            end
          end
        end
      end
    end
  end
end
