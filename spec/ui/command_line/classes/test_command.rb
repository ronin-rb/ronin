require 'ronin/ui/command_line/command'

class TestCommand < Ronin::UI::CommandLine::Command

  desc 'Tests the default task'
  def execute
    'default task'
  end

end
