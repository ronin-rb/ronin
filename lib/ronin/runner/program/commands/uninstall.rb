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
      class UninstallCommand < Command

        command :uninstall

        options('NAME [NAME ...] [options]') do |opts|
          opts.options

          opts.arguments do
            opts.arg('NAME','The repository to uninstall')
          end

          opts.summary('Uninstall the specified repositories')
        end

        def arguments(*args)
          args.each do |name|
            Cache::Overlay.save_cache do
              Cache::Overlay.uninstall(name) do |repo|
                puts "Uninstalling #{repo}..."
              end
            end
          end
        end

      end
    end
  end
end
