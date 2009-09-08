require 'yard'

module YARD
  module Handlers
    module Ruby
      module Legacy
        class HasHandler < Base

          handles /\Ahas\s+([1-9]\d*|n|(0|1)\.\.n),\s/

          def process
            nobj = namespace
            mscope = scope
            name = statement.tokens[2..-1].to_s[/:[^,]+/][1..-1]

            register MethodObject.new(nobj, name, :class) do |o|
              o.visibility = :public
              o.source = statement.source
              o.signature = "def self.#{name}"
              o.parameters = [['repository', 'nil']]
            end

            register MethodObject.new(nobj, name, mscope) do |o|
              o.visibility = :public
              o.source = statement.source
              o.signature = "def #{name}"
            end
          end

        end
      end
    end
  end
end
