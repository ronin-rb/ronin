require 'ronin/ui/cli/command'

class TestCommand < Ronin::UI::CLI::Command

  summary 'Tests the default task'

  option :foo, :type => true

  def execute
    if @foo
      'foo task'
    else
      'default task'
    end
  end

end
