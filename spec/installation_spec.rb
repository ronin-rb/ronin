require 'ronin/installation'

require 'spec_helper'

describe Installation do
  before(:each) do
    @ronin_gem = mock(
      'ronin gem',
      :name => 'ronin',
      :files => %w{
        lib/ronin/ui/command_line/commands/add.rb
        lib/ronin/ui/command_line/commands/console.rb
        lib/ronin/ui/command_line/commands/database.rb
        lib/ronin/ui/command_line/commands/help.rb
        lib/ronin/ui/command_line/commands/install.rb
        lib/ronin/ui/command_line/commands/list.rb
        lib/ronin/ui/command_line/commands/uninstall.rb
        lib/ronin/ui/command_line/commands/update.rb
      },
      :dependent_gems => []
    )

    @ronin_exploits_gem = mock(
      'ronin-exploits gem',
      :name => 'ronin-exploits',
      :files => %w{
        lib/ronin/ui/command_line/commands/exploit.rb
        lib/ronin/ui/command_line/commands/exploits.rb
        lib/ronin/ui/command_line/commands/payload.rb
        lib/ronin/ui/command_line/commands/payloads.rb
      },
      :dependent_gems => [@ronin_gem]
    )

    Installation.stub!(:gems).and_return(
      'ronin' => @ronin_gem,
      'ronin-exploits' => @ronin_exploits_gem
    )
  end

  it "should provide the names of the installed Ronin libraries" do
    Installation.libraries.should == ['ronin', 'ronin-exploits']
  end

  it "should enumerate over every file from every Ronin library" do
    Installation.enum_for(:each_file).to_a.should == %w{
      lib/ronin/ui/command_line/commands/add.rb
      lib/ronin/ui/command_line/commands/console.rb
      lib/ronin/ui/command_line/commands/database.rb
      lib/ronin/ui/command_line/commands/help.rb
      lib/ronin/ui/command_line/commands/install.rb
      lib/ronin/ui/command_line/commands/list.rb
      lib/ronin/ui/command_line/commands/uninstall.rb
      lib/ronin/ui/command_line/commands/update.rb
      lib/ronin/ui/command_line/commands/exploit.rb
      lib/ronin/ui/command_line/commands/exploits.rb
      lib/ronin/ui/command_line/commands/payload.rb
      lib/ronin/ui/command_line/commands/payloads.rb
    }
  end

  it "should enumerate over the files within a certain directory" do
    directory = 'lib/ronin/ui/command_line/commands'

    Installation.enum_for(:each_file_in,directory).to_a.should == %w{
      add.rb
      console.rb
      database.rb
      help.rb
      install.rb
      list.rb
      uninstall.rb
      update.rb
      exploit.rb
      exploits.rb
      payload.rb
      payloads.rb
    }
  end
end
