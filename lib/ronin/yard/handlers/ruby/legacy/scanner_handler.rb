#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'yard'

module YARD
  module Handlers
    module Ruby
      module Legacy
        class ScannerHandler < Base

          handles /\Ascanner(\s+|\()/

          def process
            nobj = namespace
            mscope = scope
            name = statement.tokens[2,1].to_s[1..-1]

            register MethodObject.new(nobj, "first_#{name}", mscope) do |o|
              o.visibility = :public
              o.source = statement.source
              o.signature = "def first_#{name}(options=true)"
              o.parameters = [['options', 'true']]
            end

            register MethodObject.new(nobj, "has_#{name}?", mscope) do |o|
              o.visibility = :public
              o.source = statement.source
              o.signature = "def has_#{name}?(options=true)"
              o.parameters = [['options', 'true']]
            end

            register MethodObject.new(nobj, "#{name}_scan", mscope) do |o|
              o.visibility = :public
              o.source = statement.source
              o.signature = "def #{name}_scan(options=true,&block)"
              o.parameters = [['options', 'true'], ['&block', nil]]
            end
          end
        end
      end
    end
  end
end
