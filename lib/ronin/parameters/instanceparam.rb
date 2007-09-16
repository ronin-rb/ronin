module Ronin
  module Parameters
    class InstanceParam < Param

      # Owning object
      attr_reader :object

      def initialize(object,name,description="")
        super(name,description)

        @object = object
      end

      def value
        @object.instance_variable_get("@#{@name}")
      end

      def value=(value)
        @object.instance_variable_set("@#{@name}",value)
      end

    end
  end
end
