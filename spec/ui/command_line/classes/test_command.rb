require 'ronin/ui/command_line/command'

class TestCommand < Ronin::UI::CommandLine::Command

  desc 'default', 'Tests the default task'
  def default
    'default task'
  end

  desc "test_name", "Tests the name method"
  def test_name
    self.name
  end

end
