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
require 'ronin/rpc/console'

module Ronin
  module RPC
    class InteractiveConsole < Interactive

      #
      # Creates a new InteractiveConsole object with the specified _console_
      # service. If a _block_ is given it will be
      #
      def initialize(console,&block)
        super(console,:prompt => '>>',&block)
      end

      #
      # Starts a newly created InteractiveConsole object with the specified
      # _service_. If a _block_ is given, it will be passed the newly
      # created InteractiveShell object, before it is started.
      #
      def self.start(console,&block)
        self.new(console,&block).start
      end

      #
      # Evaluates the specified _code_ through the Console service and
      # prints the natively formated return-value.
      #
      def process_command(code)
        puts "=> #{@service.inspect(code)}"
      end

    end
  end
end
