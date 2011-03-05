require 'ronin/ui/cli/command'

class TestCommand < Ronin::UI::CLI::Command

  desc 'Tests the default task'

  class_option :foo, :type => :boolean

  def execute
    if options.foo?
      'foo task'
    else
      'default task'
    end
  end

end
