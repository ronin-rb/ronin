require 'ronin/ui/command_line/command'

class TestCommand < Ronin::UI::CommandLine::Command

  map '-m' => :mapped_task

  no_tasks do
    def test_name
      self.name
    end
  end

  desc 'default', 'Tests the default task'
  def default
    'default task'
  end

  desc "mapped_task", "An example mapped task"
  def mapped_task
    'mapped task'
  end

end
