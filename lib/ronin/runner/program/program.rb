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
require 'ronin/console'
require 'ronin/version'

module Ronin
  module Runner
    module Program
      def Program.commands
        @@commands ||= []
      end

      def Program.commands_by_name
        @@commands_by_name ||= {}
      end

      def Program.has_command?(name)
        Program.commands_by_name.has_key?(name.to_s)
      end

      def Program.get_command(name)
        name = name.to_s

        unless Program.has_command?(name)
          raise(UnknownCommand,"unknown command #{name.dump}",caller)
        end

        return Program.commands_by_name[name]
      end

      def Program.error(message)
        $stderr.puts "ronin: #{message}"
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
        if topic
          begin
            get_command(topic).help
          rescue UnknownCommand => exp
            Program.fail(exp)
          end
        else
          puts 'Available commands:'

          Program.commands.each do |cmd|
            puts "  #{cmd.command_names.join(', ')}"
          end
        end
      end

      def Program.default_command(*argv)
        Options.new('ronin','<command> [options]') { |opts|
          opts.options do |opts|
            opts.on('-r','--require LIB','require the specified library or path') do |lib|
              Console.auto_load << lib.to_s
            end

            opts.on('-V','--version','print version information and exit') do
              Program.success do
                puts "Ronin #{Ronin::VERSION}"
              end
            end
          end

          opts.summary('Ronin is a Ruby development platform designed for information security','and data exploration tasks.')
        }.parse(argv) { |opts,args|
          Console.start
        }
      end

      def Program.run(*argv)
        begin
          if (argv.empty? || argv[0][0..0]=='-')
            Program.default_command(*argv)
          else
            cmd = argv.first
            argv = argv[1..-1]

            if Program.has_command?(cmd)
              Program.commands_by_name[cmd].run(*argv)
            else
              Program.fail("unknown command #{cmd.dump}")
            end
          end
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption => e
          Program.fail(e)
        end

        return true
      end
    end
  end
end
