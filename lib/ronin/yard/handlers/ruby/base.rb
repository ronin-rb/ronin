require 'yard'

module YARD
  module Handlers
    module Ruby
      class Base < Handlers::Base

        protected

        def effected_namespace
          if statement.type == :command_call
            context = statement.jump(:var_ref)

            unless context.source == 'self'
              return ensure_loaded!(
                Registry.resolve(namespace,context.source)
              )
            end
          end

          return namespace
        end

      end
    end
  end
end
