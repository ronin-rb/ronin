#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/rpc/interactive'
require 'ronin/shell'

module Ronin
  module RPC
    class InteractiveShell < Interactive

      #
      # Creates a new InteractiveShell object with the specified _shell_
      # service. If a _block_ is given it will be passed the newly created
      # InteractiveShell object.
      #
      def initialize(shell,&block)
        super(shell,:prompt => '$',&block)
      end

      #
      # Starts a newly created InteractiveShell object using the specified
      # _shell_ service. If a _block_ is given, it will be passed the newly
      # created InteractiveShell before it is started.
      #
      def self.start(shell,&block)
        self.new(shell,&block).start
      end

      #
      # Executes the specified _command_ through the Shell service
      # and prints the output of the command.
      #
      def process_command(command)
        @service.system(command)
      end

    end
  end
end
