# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/cli/string_methods_command'
require 'ronin/support/compression'
require 'ronin/support/archive'

module Ronin
  class CLI
    module Commands
      #
      # Compress the files.
      #
      # ## Usage
      #
      #     ronin compress [option] [FILE ...]
      #
      # ## Options
      #
      #     -z, --zip                        zip archive the data
      #     -t, --tar                        tar archive the data
      #     -g, --gzip                       gzip compresses the data
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to compress
      #
      class Compress < StringMethodsCommand
        usage '[option] [FILE ...]'

        option :gzip, short: '-g',
                      desc:  'gzip compresses the data' do
                        @format = :gzip
                      end

        option :tar, short: '-t',
                     desc:  'tar archive the data' do
                       @format = :tar
                     end

        option :zip, short: '-z',
                     desc:  'zip archive the data' do
                       @format = :zip
                     end

        description 'Compress the data'

        man_page 'ronin-compress.1'

        #
        # The compression format.
        #
        # @return Symbol
        #
        attr_reader :format

        def initialize(**kwargs)
          super(**kwargs)

          @format = :gzip
        end

        def process_file(file)
          compression_class.send(@format, "#{file}.#{extension}") do |c|
            c.write File.read(file)
          end
        end

        private

        def compression_class
          if @format == :gzip
            Ronin::Support::Compression
          else
            Ronin::Support::Archive
          end
        end

        def extension
          return "gz" if @format == :gzip

          @format.to_s
        end
      end
    end
  end
end
