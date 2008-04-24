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

require 'ronin/runner/program/command'
require 'ronin/cache/repository'

module Ronin
  module Runner
    module Program
      class AddCommand < Command

        command :add

        options('PATH [options]') do |opts|
          opts.settings.media = :local
          opts.settings.uri = nil

          opts.options do
            opts.on('-m','--media MEDIA','Spedify the media-type of the repository') do |media|
              opts.settings.media = media
            end

            opts.on('-U','--uri URI','Specify the source URI of the repository') do |uri|
              opts.settings.uri = uri
            end
          end

          opts.arguments do
            opts.arg('PATH','Add the repository located at the specified PATH')
          end

          opts.summary('Add a local repository located at the specified PATH to the repository cache')

          opts.defaults('--media local')
        end

        def arguments(*args)
          unless args.length==1
            fail('add: only one repository path maybe specified')
          end

          path = args.first

          Cache::Repository.save_cache do
            Cache::Repository.add(path,options.settings.media,options.settings.uri) do |repo|
              puts "Repository #{repo} added."
            end
          end
        end

      end
    end
  end
end
