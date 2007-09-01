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

require 'ronin/code/asm/labelblock'

module Ronin
  module Code
    module ASM
      class Directive < LabelBlock

        # Name of the directive
        attr_reader :name

        # Arguments of the directive
        attr_accessor :args

        def initialize(style,name,*args,&block)
          @name = name.to_sym
          @args = args

          super(style,&block)
        end

        def compile
          ["#{@name} #{@args.join(', ')}"] + super
        end

        def ==(directive)
          return false unless @name==directive.name
          return false unless @args==directive.args

          return super(directive)
        end

      end
    end
  end
end
