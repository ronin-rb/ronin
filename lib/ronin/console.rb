#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

      trap('SIGINT') do
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
