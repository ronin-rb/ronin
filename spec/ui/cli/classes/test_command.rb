require 'ronin/ui/cli/command'

class TestCommand < Ronin::UI::CLI::Command

  desc 'Tests the default task'

  def execute
    'default task'
  end

end
