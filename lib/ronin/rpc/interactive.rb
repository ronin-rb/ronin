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

require 'ronin/shell'

module Ronin
  module RPC
    class Interactive < Ronin::Shell

      # The service to interactive with
      attr_reader :service

      #
      # Creates a new Interactive object using the specified _service_ and
      # the given _options_. If a _block_ is given it will be passed the
      # newly created Interactive object.
      #
      def initialize(service,options={},&block)
        @service = service

        super(options,&block)
      end

      #
      # Starts a newly created Interactive object with the specified
      # _service_ with the given _options_. If a _block_ is given, it will
      # be passed the newly created Interactive object, before it is started.
      #
      def Interactive.start(service,options={},&block)
        Interactive.new(service,options,&block).start
      end

    end
  end
end
