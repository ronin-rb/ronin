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
      #     -f, --file FILE                  Optional file to process
      #         --string STRING              Optional string to process
      #     --format gzip|zlib               Compression format
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to compress
      #
      class Compress < StringMethodsCommand
        usage '[options] [FILE ...]'

        option :format, value: {
                          type: [:gzip, :zlib_deflate]
                        },
                        desc: 'Compression format'

        description 'Compress the data'

        man_page 'ronin-compress.1'

        #
        # Size of file read at one time.
        #
        CHUNK_SIZE = 4096

        #
        # Reads and processes file.
        #
        # @param [String] path
        #   The path to the file.
        #
        def process_file(file)
          case format
          when :gzip
            Ronin::Support::Compression.gzip("#{file}.gz") do |gzip|
              File.open(file, 'rb') do |f|
                gzip.write(f.readpartial(CHUNK_SIZE)) until f.eof?
              end
            end
          when :zlib_deflate
            content            = File.read(file)
            compressed_content = Ronin::Support::Compression.zlib_deflate(content)
            File.binwrite("#{file}.zlib", compressed_content)
          end
        end

        #
        # Compress the string.
        #
        # @param [String] string
        #   The input string.
        #
        # @return [String]
        #   The compressed string.
        #
        def process_string(string)
          case format
          when :gzip
            buffer = StringIO.new(encoding: Encoding::ASCII_8BIT)

            Ronin::Support::Compression::Gzip::Writer.wrap(buffer) do |gz|
              gz.write(string)
            end

            buffer.string
          when :zlib_deflate
            Ronin::Support::Compression.zlib_deflate(string)
          end
        end

        #
        # Returns format option
        #
        # @api private
        #
        def format
          options.fetch(:format) do
            print_error "must specify the --format option"
            exit(1)
          end
        end
      end
    end
  end
end
