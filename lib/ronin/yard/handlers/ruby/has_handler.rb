require 'yard'

require 'ronin/yard/handlers/ruby/base'

module YARD
  module Handlers
    module Ruby
      class HasHandler < Base

        handles method_call(:has)

        def process
          args = statement.parameters
          n = args[0].last
          name = args[1].last

          if (name.type == :symbol &&
              ((n.type == :int && n.source =~ /^[0-9]\d*$/) ||
              (n.type == :ident && n.source == 'n')))
            nobj = effected_namespace
            mscope = scope
            name = name.source[1..-1]

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

            register MethodObject.new(nobj, "#{name}=", mscope) do |o|
              o.visibility = :public
              o.source = statement.source
              o.signature = "def #{name}="
              o.parameters = [["new_#{name}", nil]]
            end
          end
        end

      end
    end
  end
end
