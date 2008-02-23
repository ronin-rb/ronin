require 'ronin/config'

require 'irb'
require 'irb/completion'

module Ronin
  module Console
    def Console.prompt
      @@console_prompt ||= :SIMPLE
    end

    def Console.prompt=(value)
      @@console_prompt = value
    end

    def Console.indent
      @@console_indent ||= true
    end

    def Console.indent=(value)
      @@console_indent = value
    end

    def Console.auto_load
      @@console_auto_load ||= []
    end

    def Console.setup(&block)
      Console.setup_blocks << block if block
    end

    def Console.start(script=nil,&block)
      IRB.setup(script)

      IRB.conf[:IRB_NAME] = 'ronin'
      IRB.conf[:PROMPT_MODE] = Console.prompt
      IRB.conf[:AUTO_INDENT] = Console.indent
      IRB.conf[:LOAD_MODULES] = Console.auto_load

      irb = IRB::Irb.new(nil,script)

      # configure the irb workspace
      irb.context.main.instance_eval do
        require 'ronin'
        require 'pp'

        include Ronin
      end

      Console.setup_blocks.each do |setup_block|
        irb.context.main.instance_eval(&setup_block)
      end

      # Load console configuration block is given
      irb.context.main.instance_eval(&block) if block

      IRB.conf[:MAIN_CONTEXT] = irb.context

      trap("SIGINT") do
        irb.signal_handle
      end

      catch(:IRB_EXIT) do
        irb.eval_input
      end

      print "\n"
      return nil
    end

    protected

    def Console.setup_blocks
      @@console_setup_blocks ||= []
    end
  end
end
