require 'yard/handlers/ruby/base'

module YARD
  module Handlers
    module Ruby
      class ScannerHandler < Base

        handles :scanner, method_call(:scanner)

        def process
          nobj = namespace
          mscope = scope
          name = if statement.type == :scanner
                   statement.jump(:ident, :op, :kw, :const).source
                 elsif statement.call?
                   obj = statement.parameters(false).first

                   case obj.type
                   when :symbol_literal
                     obj.jump(:ident, :op, :kw, :const).source
                   when :string_literal
                     obj.jump(:string_content).source
                   end
                 end


          register MethodObject.new(nobj, "first_#{name}", mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def first_#{name}(options=true)"
            o.parameters = [['options', 'true']]
          end

          register MethodObject.new(nobj, "has_#{name}?", mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def has_#{name}?(options=true)"
            o.parameters = [['options', 'true']]
          end

          register MethodObject.new(nobj, "#{name}_scan", mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def #{name}_scan(options=true,&block)"
            o.parameters = [['options', 'true'], ['&block', nil]]
          end
        end

      end
    end
  end
end
