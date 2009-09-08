require 'yard'

module YARD
  module Handlers
    module Ruby
      class HasHandler < Base

        handles method_call(:has)

        def process
          n = statement[1].jump(:int, :ident)

          if ((n.type == :int && n.source =~ /^[0-9]\d*$/) || 
              (n.type == :ident && n.source == 'n'))
            nobj = namespace
            mscope = scope
            name = statement.jump(:symbol).source[1..-1]

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
