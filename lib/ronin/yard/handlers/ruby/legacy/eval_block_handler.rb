require 'yard/handlers/ruby/legacy/base'

module YARD
  module Handlers
    module Ruby
      module Legacy
        class EvalBlockHandler < Base

          handles /(\A|\.)(module|class|instance)_eval(\s+|\()/

          def process
            parse_block if statement.block
          end

        end
      end
    end
  end
end
