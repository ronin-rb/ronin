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
require 'ronin/code/asm/section'

module Ronin
  module Code
    module ASM
      class Program < LabelBlock

        # Sections of the program
        attr_accessor :sections

        def initialize(style,&block)
          @sections = Hash.new { |hash,key| hash[key.to_sym] = [] }
          @current_section = nil

          super(style,&block)
        end

        def has_section?(name)
          name = name.to_sym

          return false unless @sections.has_key?(name)
          return !(@sections[name].empty?)
        end

        def get_section(name,&block)
          name = name.to_sym

          @sections[name].each(&block) if block
          return @sections[name]
        end

        def ==(program)
          return false unless @sections==program.sections

          return super(program)
        end

        def +(section)
          new_section = super(section)
          new_section.sections += @sections

          return new_section
        end

        def <<(obj)
          if obj.kind_of?(Section)
            enter_section(obj)
          elsif @current_section
            @current_section << obj
          else
            super(obj)
          end

          return self
        end

        protected

        def enter_section(section)
          # set the current section
          @current_section = section
          @current_label = nil

          # add a new section
          @sections[section.name] << section
          @elements << section
        end

      end
    end
  end
end
