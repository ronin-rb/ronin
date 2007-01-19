module Ronin
  class Param

    # Name of parameter
    attr_reader :name

    # Description of parameter
    attr_reader :description

    # Value associated with parameter
    attr_accessor :value

    def initialize(name,description="",value=nil)
      @name = name
      @description = description
      @value = value
    end

  end

  class Parameters < Hash

    def <<(param)
      self[param.name] = param
    end

  end
end
