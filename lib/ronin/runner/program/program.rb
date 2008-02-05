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

require 'ronin/runner/program/command'
require 'ronin/runner/program/options'
require 'ronin/runner/program/exceptions/unknown_command'
require 'ronin/version'

module Ronin
  module Runner
    module Program
      def Program.commands
        @@commands ||= []
      end

      def Program.command_names
        @@command_names ||= {}
      end

      def Program.has_command?(name)
        Program.command_names.has_key?(name.to_s)
      end

      def Program.get_command(name)
        name = name.to_s

        unless Program.has_command?(name)
          raise(UnknownCommand,"unknown command #{name.dump}",caller)
        end

        return Program.command_names[name]
      end

      def Program.command(name,*short_names,&block)
        new_command = Command.new(name,*short_names,&block)
        Program.commands << new_command

        Program.command_names[name.to_s] = new_command
        short_names.each do |short_name|
          Program.command_names[short_name.to_s] = new_command
        end

        return new_command
      end

      def Program.error(message)
        $stderr << "ronin: #{message}\n"
        return false
      end

      def Program.success(&block)
        block.call(self) if block
        exit
      end

      def Program.fail(*messages,&block)
        block.call(self) if block

        messages.each do |mesg|
          Program.error(mesg)
        end

        exit -1
      end

      def Program.help(topic=nil)
        success do
          if topic
            begin
              get_command(topic).help
            rescue UnknownCommand => exp
              Program.fail(exp)
            end
          else
            puts "Available commands:"

            Program.commands.each do |cmd|
              puts "  #{cmd}"
            end
          end
        end

        return true
      end

      def Program.default_command(*argv)
        options = Options.new('ronin','<command> [options] [args]') do |options|
          options.common do
            options.on_help do
              Program.help
            end

            options.on('-V','--version','print version information and exit') do
              Program.success do
                puts "Ronin #{Ronin::VERSION}"
              end
            end
          end

          options.summary('Ronin is a Ruby development platform designed for information security','and data exploration tasks.')
        end

        options.parse(argv) do |args|
          options.help unless args.empty?

          Program.success do
            Program.help
          end
        end
      end

      def Program.run(*argv)
        begin
          if (argv.empty? || argv[0][0..0]=='-')
            Program.default_command(*argv)
          else
            cmd = argv.first

            begin
              Program.get_command(cmd).run(*(argv[1..-1]))
            rescue UnknownCommand => e
              Program.fail(e)
            end
          end
        rescue OptionParser::InvalidOption => e
          Program.fail(e)
        end

        return true
      end
    end
  end
end
