#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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
#

require 'audit/report'

module Ronin
  module Audit
    module Web
      module SQL
	class SQLReport < Report

	  # URL that was injected
	  attr_accessor :url

	  # Parameters of the URL
	  attr_accessor :params

	  # Parameters that where injected
	  attr_accessor :injection_params

	  # Injectable parameters
	  attr_accessor :injectable_params

	  # Was the URL accessed via GET or POST
	  attr_accessor :post

	  def initialize(url,params,injection_params,post,&block)
	    @params = {}
	    @injection_params = []
	    @injectable_params = []
	    @post = false

	    super(&block)
	  end

	end
      end
    end
  end
end
