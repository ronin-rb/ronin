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

module Ronin
  class Taxonomy

    class Modifier

      # Type of modifier (in, at, on, ...)
      attr_reader :type

      # Object that to be modified
      attr_reader :object

      def initialize(type,object)
	@type = type
	@object = object
      end

      def to_s
	"#{type} #{object}"
      end

    end

    # The action to be performed
    attr_reader :action

    # The resource to perform upon
    attr_reader :resource

    # Modifiers of the action
    attr_reader :modifiers

    def initialize(action,resource=nil,modifiers=[])
      @action = action
      @resource = resource
      @modifiers = modifiers
    end

    def to_s
      if @modifiers.empty?
	if @resource
          return "#{@action} #{@resource}"
	else
	  return "#{@action}"
	end
      else
	if @resource
	  return "#{@action} #{@resource} #{@modifiers.join(' ')}"
	else
	  return "#{@action} #{@modifiers.join(' ')}"
	end
      end
    end

  end

end
