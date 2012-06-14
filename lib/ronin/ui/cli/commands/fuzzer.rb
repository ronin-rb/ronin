#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/ui/cli/command'
require 'ronin/fuzzing'

require 'shellwords'
require 'tempfile'
require 'socket'

module Ronin
  module UI
    module CLI
      module Commands
        class Fuzzer < Command

          summary 'Performs basic fuzzing of files'

          option :fuzz, :type => Hash[String => String],
                        :flag => '-F',
                        :usage => '[PATTERN|/REGEXP/]:[METHOD|STR*N[-M]]',
                        :description => 'Fuzzing rules'

          option :input, :type => String,
                         :flag => '-i',
                         :usage => 'FILE',
                         :description => 'Input file to fuzz'

          option :file, :type => String,
                        :flag => '-f',
                        :usgae => 'PATH',
                        :description => 'Output file path'

          option :command, :type => String,
                           :flag => '-c',
                           :usage => 'PROGRAM [OPTIONS|#string#|#path#] ...',
                           :description => 'Template command to run'

          option :server, :type => String,
                          :flag => '-s',
                          :usage => 'HOST:PORT',
                          :description => 'Server to send the fuzzed data to'

          examples [
            "ronin fuzzer -i request.txt -F unix_path:bad_strings -f bad.txt"
          ]

          def execute
            data   = File.read(@input)
            method = if file?
                       @file_ext  = File.extname(@file)
                       @file_name = @file.chomp(@file_ext)

                       method(:fuzz_file)
                     elsif command?
                       @command = shellwords(@command)

                       method(:fuzz_command)
                     elsif server?
                       @server_host, @server_port = @server.split(':',2)
                       @server_port = @server_port.to_i

                       method(:fuzz_server)
                     else
                       method(:fuzz_stdout)
                     end

            data.fuzz(parse_rules).each_with_index do |string,index|
              index = index + 1

              method.call(string,index)
            end
          end

          protected

          include Shellwords

          def fuzz_file(string,index)
            path = "#{@file_name}-#{index}#{@file_ext}"

            print_info "Creating file ##{index}: #{path} ..."

            File.open(path,'wb') do |file|
              file.write string
            end
          end

          def fuzz_command(string,index)
            Tempfile.open("ronin-fuzzer-#{index}") do |tempfile|
              tempfile.write(string)
              tempfile.flush

              arguments = @command.map do |argument|
                if argument.include?('#path#')
                  argument.sub('#path#',tempfile.path)
                elsif argument.include?('#string#')
                  argument.sub('#string#',string)
                else
                  argument
                end
              end

              print_info "Running command #{index}: #{arguments.join(' ')} ..."

              # run the command as it's own process
              unless system(*arguments)
                status = $?

                if status.coredump?
                  # jack pot!
                  print_error "Process ##{status.pid} coredumped!"
                else
                  # process errored out
                  print_warning "Process ##{status.pid} exited with status #{status.exitstatus}"
                end
              end
            end
          end

          def fuzz_server(string,index)
            print_debug "Connecting to #{@server_host}:#{@server_port} ..."

            socket = TCPSocket.new(@server_host,@server_port)

            print_info "Sending message ##{index}: #{string.inspect} ..."
            socket.write(string)

            socket.flush
            socket.close
          end

          def fuzz_stdout(string,index)
            print_debug "String ##{index} ..."

            puts string
          end

          def parse_rules
            rules = {}

            @fuzz.each do |key,value|
              pattern = if key =~ /^\/.+\/$/
                          Regexp.new(key[1..-2])
                        elsif (Regexp.const_defined?(key.upcase) &&
                               Regexp.const_get(key.upcase).kind_of?(Regexp))
                          Regexp.const_get(key.upcase)
                        else
                          key
                        end

              substitution = if value.include?('*')
                               string, lengths = value.split('*',2)

                               lengths = if lengths.include?('-')
                                          min, max = lengths.split('-',2)

                                          (min.to_i .. max.to_i)
                                        else
                                          lengths.to_i
                                        end

                               string.repeating(lengths)
                             else
                               Fuzzing[value]
                             end

              rules[pattern] = substitution
            end

            return rules
          end

        end
      end
    end
  end
end
