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

require 'ronin/extensions/meta'
require 'ronin/code/asm/directive'
require 'ronin/code/asm/instruction'
require 'ronin/code/asm/register'

module Ronin
  module Code
    module ASM
      module Dialect
        protected

        def self.asm_name(klass)
          klass.name.downcase.gsub(/^.+::/,'').to_sym
        end

        def self.directives
          @@directives ||= {}
        end

        def self.has_directive?(name)
          self.directives.has_key?(name.to_sym)
        end

        def self.directive(klass,id=asm_name(klass))
          self.directives[id] = klass

          module_eval %{
            def #{id}(*args,&block)
              self << #{klass}.new(@style,*args,&block)
            end
          }
        end

        def self.instructions
          @@instructions ||= {}
        end

        def self.has_instruction?(name)
          self.instructions.has_key?(name.to_sym)
        end

        def self.instruction(klass,opts={:name => asm_name(klass), :suffixes => []})
          instructions[opts[:name]] = klass

          # define the instruction method
          class_def(opts[:name]) do |*args|
            self << klass.new(@style,:args => args)
          end

          # define the instruction suffix methods
          opts[:suffixes].each do |suffix|
            class_def("#{opts[:name]}#{suffix}") do |*args|
              self << klass.new(@style,:suffix => suffix, :args => args)
            end
          end
        end

        def self.register(*regs)
          for reg in regs
            reg = reg.to_sym

            class_def(reg) do
              registers[reg]
            end
          end
        end

        def comment(text)
          self << Comment.new(@style,text)
        end

        def registers
          @registers ||= Hash.new { |hash,key| hash[key.to_sym] = Register.new(@style,key) }
        end

        def reg(name)
          registers[name]
        end

        def deref(base,index=0,scale=1)
          Deref.new(@style,base,index,scale)
        end

        def instruction(name,*args)
          self << Instruction.new(@style,name,*args)
        end

        def directive(name,*args,&block)
          self << Directive.new(@style,name,*args,&block)
        end
      end
    end
  end
end
