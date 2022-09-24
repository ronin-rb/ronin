#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

module Ronin
  class CLI
    #
    # Adds the `--key` and `--key-file` options to a command.
    #
    module KeyOptions
      #
      # Adds the `--key` and `--key-file` options to the including command.
      #
      # @param [Class] command
      #   The command including {KeyOptions}.
      #
      def self.included(command)
        command.option :key, short: '-k',
                             value: {
                               type:  String,
                               usage: 'STRING'
                             },
                             desc: 'The key String' do |string|
                               @key = string
                             end

        command.option :key_file, short: '-K',
                                  value: {
                                    type:  String,
                                    usage: 'FILE'
                                  },
                                  desc: 'The key file' do |path|
                                    begin
                                      @key = File.binread(path)
                                    rescue Errno::ENOENT
                                      raise(OptionParser::InvalidArgument,"no such file or directory: #{path.inspect}")
                                    end
                                  end
      end

      # The key string.
      #
      # @return [String]
      attr_reader :key
    end
  end
end
