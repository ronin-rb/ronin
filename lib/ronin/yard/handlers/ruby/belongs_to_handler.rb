require 'yard'

require 'ronin/yard/handlers/ruby/base'

module YARD
  module Handlers
    module Ruby
      class BelongsToHandler < Base

        handles method_call(:belongs_to)

        def process
          nobj = effected_namespace
          mscope = scope
          name = statement.parameters[0].last
          
          if name.type == :symbol
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
              o.signature = "def #{name}=(resource)"
              o.parameters = [['resource', nil]]
            end
          end
        end

      end
    end
  end
end
