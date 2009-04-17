require 'ronin/ui/command_line/command'

class ExampleCommand < UI::CommandLine::Command

  include UI::CommandLine::ParamParser

  attr_reader :params

  def initialize(name)
    @params = {}

    super(name)
  end

  def param_parser(name_and_value)
    @params.merge!(parse_param(name_and_value))

    return @params
  end

end
