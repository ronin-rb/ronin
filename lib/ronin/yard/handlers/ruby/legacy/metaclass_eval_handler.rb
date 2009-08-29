require 'yard/handlers/ruby/legacy/base'

module YARD
  module Handlers
    module Ruby
      module Legacy
        class MetaclassEvalHandler < Base

          handles /(\A|\.)metaclass_eval(\s+|\()/

          def process
            if statement.block
              parse_block(:namespace => namespace, :scope => :class)
            end
          end

        end
      end
    end
  end
end
