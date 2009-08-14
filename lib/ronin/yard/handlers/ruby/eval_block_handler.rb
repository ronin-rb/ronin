require 'yard'

module YARD
  module Handlers
    module Ruby
      class EvalBlockHandler < YARD::Handlers::Ruby::Base

        handles method_call(:module_eval), method_call(:class_eval), method_call(:instance_eval)

        def process
          if (block = statement.jump(:do_block).last)
            parse_block(block)
          end
        end
      end
    end
  end
end
