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

require 'ronin/code/asm/block'
require 'ronin/code/asm/label'
require 'ronin/code/asm/exceptions/labelredefined'

module Ronin
  module Code
    module ASM
      class LabelBlock < Block

        # Labels defined within the block
        attr_accessor :labels

        def initialize(style,&block)
          @labels = {}
          @current_label

          super(style,&block)
        end

        def label(name,&block)
          new_label = Label.new(name,@style,&block)
          enter_label(new_label)

          return new_label
        end

        def has_label?(name)
          @labels.has_key?(name)
        end

        def get_label(name)
          @labels[name]
        end

        def ==(block)
          return false unless @labels==block.labels

          return super(block)
        end

        def +(block)
          new_block = super(block)
          new_block.labels.merge(block.labels)

          return new_block
        end

        def <<(obj)
          if obj.kind_of?(Label)
            enter_label(obj)
          elsif @current_label
            # append to the contents of the current label
            @current_label << obj
          else
            super(obj)
          end

          return self
        end

        protected

        def enter_label(label)
          if has_label?(label.name)
            raise(LabelRedefined,"label '#{label.name}' is already defined",caller)
          end

          # set as the new current label
          @current_label = label

          # add the new label
          @labels[label.name] = label
          @ements << label
        end

      end
    end
  end
end
