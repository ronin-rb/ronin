require 'yard'

module YARD
  module Handlers
    module Ruby
      class MetaclassEvalHandler < YARD::Handlers::Ruby::Base

        handles method_call(:metaclass_eval)

        def process
          if (block = statement.jump(:brace_block, :do_block).last)
            parse_block(block, :namespace => namespace, :scope => :class)
          end
        end
      end
    end
  end
end
