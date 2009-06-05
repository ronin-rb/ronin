#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/config'

require 'irb'

module Ronin
  module UI
    module Console
      # Default prompt style.
      PROMPT = :SIMPLE

      # Default indentation mode.
      INDENT = true

      # Default backtrace depth.
      BACKTRACE_DEPTH = 5

      # Default completion mode.
      COMPLETION = true

      #
      # Returns the default Console prompt style, defaults to +PROMPT+.
      #
      def Console.prompt
        @@ronin_console_prompt ||= PROMPT
      end

      #
      # Sets the default Console prompt style to the specified _style_.
      #
      def Console.prompt=(style)
        @@ronin_console_prompt = style
      end

      #
      # Returns the default Console indent setting, defaults to +INDENT+.
      #
      def Console.indent
        @@ronin_console_indent ||= INDENT
      end

      #
      # Sets the default Console indent setting to the specified _mode_.
      #
      #   Console.indent = false
      #   # => false
      #
      def Console.indent=(mode)
        @@ronin_console_indent = mode
      end

      #
      # Returns the default Console back trace limit, defaults to
      # +BACKTRACE_DEPTH+.
      #
      def Console.backtrace_depth
        @@ronin_console_backtrace_depth ||= BACKTRACE_DEPTH
      end

      #
      # Sets the default Console back trace depth to the specified _depth_.
      #
      def Console.backtrace_depth=(depth)
        @@ronin_console_backtrace_depth = depth
      end

      #
      # Returns the default Console tab-completion mode, defaults to
      # +COMPLETION+.
      #
      def Console.completion
        @@ronin_console_completion ||= COMPLETION
      end

      #
      # Sets the default Console tab-completion mode to the specified
      # _mode_.
      #
      #   Console.completion = false
      #   # => false
      #
      def Console.completion=(mode)
        @@ronin_console_completion = mode
      end

      #
      # Returns the Array of files to require when the Console starts.
      #
      def Console.auto_load
        @@ronin_console_auto_load ||= []
      end

      #
      # Calls the specified _block_ from within the Console after it is
      # started.
      #
      def Console.setup(&block)
        Console.setup_blocks << block if block
      end

      #
      # Starts a Console with the given _script_. If a _block_ is given, it
      # will be called from within the Console.
      #
      def Console.start(script=nil,&block)
        IRB.setup(script)

        # configure IRB
        IRB.conf[:IRB_NAME] = 'ronin'
        IRB.conf[:PROMPT_MODE] = Console.prompt
        IRB.conf[:AUTO_INDENT] = Console.indent
        IRB.conf[:BACK_TRACE_LIMIT] = Console.backtrace_depth

        irb = IRB::Irb.new(nil,script)

        # configure the IRB context
        irb.context.main.instance_eval do
          require 'ronin/environment'
          require 'ronin/platform'

          require 'irb/completion' if Ronin::UI::Console.completion

          # require any of the auto-load paths
          Ronin::UI::Console.auto_load.each do |path|
            require path
          end

          include Ronin
        end

        # run any setup-blocks
        Console.setup_blocks.each do |setup_block|
          irb.context.main.instance_eval(&setup_block)
        end

        # run the supplied configuration block is given
        irb.context.main.instance_eval(&block) if block

        IRB.conf[:MAIN_CONTEXT] = irb.context

        trap('SIGINT') { irb.signal_handle }
        catch(:IRB_EXIT) { irb.eval_input }

        putc "\n"
        return nil
      end

      protected

      #
      # Returns the Array of setup_blocks to run within the Console after it
      # is started.
      #
      def Console.setup_blocks
        @@console_setup_blocks ||= []
      end
    end
  end
end
