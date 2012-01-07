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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin. If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/ui/cli/command'
require 'ronin/wordlist'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-wordlist` command.
        #
        # @since 1.4.0
        #
        class Wordlist < Command

          option :input, :type => String,
                         :flag => '-i',
                         :usage => 'FILE',
                         :description => 'Input file'

          option :output, :type => String,
                          :flag => '-o',
                          :usage => 'PATH',
                          :description => 'Output wordlist file'

          option :mutations, :type    => Hash[String => Array],
                             :default => {},
                             :flag    => '-m',
                             :usage   => 'STRING:SUB',
                             :descriptions => 'Mutations rules'

          argument :template, :type => Array

          #
          # Executes the wordlist command.
          #
          def execute
            if (input? && template?)
              print_error "Cannot specify --input with the TEMPLATE argument"
              exit -1
            end

            output_stream do |output|
              wordlist.each { |word| output.puts word }
            end
          end

          protected

          #
          # Parses the `TEMPLATE` argument.
          #
          # @return [Array<String, Array<String>, (Symbol, Integer)>]
          #   The String building template.
          #
          # @see http://rubydoc.info/gems/ronin-support/String#generate-class_method
          #
          def parse_template
            @template.map do |char_template|
              if char_template.include?(':')
                charset, length = char_template.split(':',2)

                # convert charset names to Symbols
                charset = if charset.include?(',')
                            charset.split(',')
                          elsif Chars.const_defined?(charset.upcase)
                            charset.to_sym
                          else
                            charset.to_s
                          end

                # parse the length field
                length = if length.include?('-')
                           min, max = length.split('-',2)

                           Range.new(min.to_i,max.to_i)
                         elsif length.include?(',')
                           length.split(',').map(&:to_i)
                         else
                           length.to_i
                         end

                [charset, length]
              else
                char_template
              end
            end
          end

          #
          # Initializes the wordlist based on the command options.
          #
          # @return [Ronin::Wordlist]
          #   The new wordlist.
          #
          # @see http://rubydoc.info/gems/ronin-support/Ronin/Wordlist
          #
          def wordlist
            if template?
              Ronin::Wordlist.new(String.generate(*parse_template),@mutations)
            elsif input?
              Ronin::Wordlist.build(File.open(@input),@mutations)
            else
              Ronin::Wordlist.build($stdin,@mutations)
            end
          end

          #
          # Opens the output stream.
          #
          # @yield [output]
          #   The output stream to write words to.
          #
          # @yieldparam [File, IO]
          #   The output file or `STDOUT`.
          #
          def output_stream(&block)
            if @output
              File.open(@output,'w',&block)
            else
              yield STDOUT
            end
          end

        end
      end
    end
  end
end
