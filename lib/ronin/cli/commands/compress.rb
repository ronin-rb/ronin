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
      #     -g, --gzip                       gzip compresses the data
      #     -z, --zlib                       zlib compress the data
      #     -n, --name                       Compressed file name
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to compress
      #
      class Compress < StringMethodsCommand
        usage '[options] [FILE ...]'

        option :gzip, short: '-g',
                      desc: 'gzip compresses the data' do
                        @compression_method = :gzip
                      end

        option :zlib, short: '-z',
                      desc: 'zlib compress the data' do
                        @compression_method = :zlib_deflate
                      end

        option :name, short: '-n',
                      value: {
                        type: String
                      },
                      desc: 'compressed file name' do |name|
                        @compressed_file_name = name
                      end

        description 'Compress the data'

        man_page 'ronin-compress.1'

        #
        # The compression format.
        #
        # @return [:gzip, :zlib_deflate]
        #
        attr_reader :compression_method

        #
        # Initializes the `ronin compress` command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @compression_method = :gzip
        end

        #
        # Runs the `compress` sub-command.
        #
        # @param [Array<String>] files
        #   File arguments.
        #
        def run(*files)
          if files.empty?
            super(*files)
          else
            raise "Files can be compressed using gzip only" if @compression_method != :gzip

            Ronin::Support::Compression.gzip(compressed_file_name) do |gz|
              files.each do |file|
                File.open(file, 'rb') do |f|
                  while (chunk = f.readpartial(4096))
                    gz.write chunk
                  end
                end
              rescue EOFError
              rescue IOError => e
                puts "Error reading file: #{e.message}"
              end
            end
          end
        end

        #
        # Reads and processes file.
        #
        # @param [String] path
        #   The path to the file.
        #
        def process_file(file)
          raise "Files can be compressed using gzip only" if @compression_method != :gzip

          Ronin::Support::Compression.gzip(compressed_file_name) do |gz|
            File.open(file, 'rb') do |f|
              while (chunk = f.readpartial(4096))
                gz.write chunk
              end
            end
          rescue EOFError
          rescue IOError => e
            puts "Error reading file: #{e.message}"
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
          string.send(@compression_method)
        end

        private

        #
        # The compressed file name.
        #
        # @return String
        #
        def compressed_file_name
          @compressed_file_name || "ronin_compressed_#{Time.now.to_i}.gz"
        end
      end
    end
  end
end
