#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/extensions/meta'
require 'ronin/runner/program/exceptions/command_not_implemented'

module Ronin
  module Runner
    module Program
      class Command

        # Formal name of the command
        attr_reader :name

        # Short-hand names of the command
        attr_reader :short_names

        def initialize(name,*short_names,&block)
          @name = name
          @short_names = short_names
          @run_block = block
        end

        def run(*argv)
          unless @run_block
            raise(CommandNotImplemented,"the command #{self.to_s.dump} has not been implemented yet",caller)
          end

          @run_block.call(argv)
          return self
        end

        def help
          run('--help')
        end

        def to_s
          unless @short_names.empty?
            return "#{@name} #{@short_names.join(', ')}"
          else
            return @name.to_s
          end
        end

      end
    end
  end
end
