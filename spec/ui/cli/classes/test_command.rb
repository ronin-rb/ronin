require 'ronin/ui/cli/command'

class TestCommand < Ronin::UI::CLI::Command

  summary 'Tests the default task'

  usage '[options] PATH FILE [..]'

  option :foo

  argument :path

  argument :files, :type => Array

  def execute
    if @foo
      'foo task'
    else
      'default task'
    end
  end

end
