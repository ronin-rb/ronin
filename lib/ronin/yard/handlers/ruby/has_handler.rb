require 'yard'

require 'ronin/yard/handlers/ruby/base'

module YARD
  module Handlers
    module Ruby
      class HasHandler < Base

        handles method_call(:has)

        def process
          n = if statement[1] == :"."
                statement[3].jump(:int, :ident)
              else
                statement.jump(:int, :ident)
              end

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
