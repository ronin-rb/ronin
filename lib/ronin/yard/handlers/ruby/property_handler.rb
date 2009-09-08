require 'yard'

module YARD
  module Handlers
    module Ruby
      class PropertyHandler < Base

        handles method_call(:property)

        def process
          nobj = namespace
          mscope = scope
          name = statement.jump(:symbol).source[1..-1]

          register MethodObject.new(nobj, name, :class) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def #{nobj}.#{name}(repository=nil)"
            o.parameters = [['repository', 'nil']]
          end

          register MethodObject.new(nobj, name, mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def #{name}"
          end

          register MethodObject.new(nobj, "#{name}=", mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def #{name}=(value)"
            o.parameters = [['value', nil]]
          end
        end

      end
    end
  end
end
