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

require_relative '../string_methods_command'

module Ronin
  class CLI
    module Commands
      #
      # Decode each character of data from a variety of encodings.
      #
      # ## Usage
      #
      #     ronin decode [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #     -s, --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #         --base16                     Base16 decodes the data
      #         --base32                     Base32 decodes the data
      #     -b, --base64=[strict|url]        Base64 decodes the data
      #     -z, --zlib                       Zlib compresses the data
      #     -g, --gzip                       gzip compresses the data
      #     -c, --c                          Decodes the data as a C string
      #     -X, --hex                        Hex decode the data (ex: "414141...")
      #     -H, --html                       HTML decodes the data
      #     -u, --uri                        URI decodes the data
      #         --http                       HTTP decodes the data
      #     -J, --java                       Decodes the data as a Java string
      #     -j, --js                         Decodes the data as a JavaScript string
      #     -n, --nodejs                     Decodes the data as a Node.js string
      #     -S, --shell                      Decodes the data as a Shell string
      #     -P, --powershell                 Decodes the data as a PowerShell string
      #         --punycode                   Decodes the data as Punycode
      #     -Q, --quoted-printable           Decodes the data as Quoted Printable
      #         --perl                       Decodes the data as a Perl string
      #     -p, --php                        Decodes the data as a PHP string
      #         --python                     Decodes the data as a Python string
      #     -R, --ruby                       Decodes the data as a Ruby string
      #         --uudecode                   uudecodes the data
      #     -x, --xml                        XML decodes the data
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Decode < StringMethodsCommand

        option :base16, desc: 'Base16 decodes the data' do
          require 'ronin/support/encoding/base16'
          @method_calls << :base16_decode
        end

        option :base32, desc: 'Base32 decodes the data' do
          require 'ronin/support/encoding/base32'
          @method_calls << :base32_decode
        end

        option :base64, short: '-b',
                        equals: true,
                        value: {
                          type: {
                            'strict' => :strict,
                            'url'    => :url_safe
                          },
                          required: false
                        },
                        desc: 'Base64 decodes the data' do |mode=nil|
                          require 'ronin/support/encoding/base64'
                          @method_calls << if mode
                                             [:base64_decode, [], {mode: mode}]
                                           else
                                             :base64_decode
                                           end
                        end

        option :zlib, short: '-z',
                      desc:  'Zlib uncompresses the data' do
                        require 'ronin/support/compression/core_ext'
                        @method_calls << :zlib_inflate
                      end

        option :gzip, short: '-g',
                      desc:  'gzip uncompresses the data' do
                        require 'ronin/support/compression/core_ext'
                        @method_calls << :gunzip
                      end

        option :c, short: '-c',
                   desc: 'Decodes the data as a C string' do
                     require 'ronin/support/encoding/c'
                     @method_calls << :c_decode
                   end

        option :hex, short: '-X',
                     desc: 'Hex decode the data (ex: "414141...")' do
                       require 'ronin/support/encoding/hex'
                       @method_calls << :hex_decode
                     end

        option :html, short: '-H',
                      desc: 'HTML decodes the data' do
                        require 'ronin/support/encoding/html'
                        @method_calls << :html_decode
                      end

        option :uri, short: '-u',
                     desc: 'URI decodes the data' do
                       require 'ronin/support/encoding/uri'
                       @method_calls << :uri_decode
                     end

        option :http, desc: 'HTTP decodes the data' do
          require 'ronin/support/encoding/http'
          @method_calls << :http_decode
        end

        option :java, short: '-J',
                      desc: 'Decodes the data as a Java string' do
                        require 'ronin/support/encoding/java'
                        @method_calls << :java_decode
                      end

        option :js, short: '-j',
                    desc: 'Decodes the data as a JavaScript string' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_decode
                    end

        option :nodejs, short: '-n',
                        desc: 'Decodes the data as a Node.js string' do
                          require 'ronin/support/encoding/node_js'
                          @method_calls << :node_js_decode
                        end

        option :shell, short: '-S',
                       desc: 'Decodes the data as a Shell string' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_decode
                       end

        option :powershell, short: '-P',
                            desc: 'Decodes the data as a PowerShell string' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_decode
                            end

        option :punycode, desc: 'Decodes the data as Punycode' do
          require 'ronin/support/encoding/punycode'
          @method_calls << :punycode_decode
        end

        option :quoted_printable, short: '-Q',
                                  desc: 'Decodes the data as Quoted Printable' do
                                    require 'ronin/support/encoding/quoted_printable'
                                    @method_calls << :quoted_printable_decode
                                  end

        option :perl, desc: 'Decodes the data as a Perl string' do
                        require 'ronin/support/encoding/perl'
                        @method_calls << :perl_decode
                      end

        option :php, short: '-p',
                     desc: 'Decodes the data as a PHP string' do
                       require 'ronin/support/encoding/php'
                       @method_calls << :php_decode
                     end

        option :python, desc: 'Decodes the data as a Python string' do
                          require 'ronin/support/encoding/python'
                          @method_calls << :python_decode
                        end

        option :ruby, short: '-R',
                      desc: 'Decodes the data as a Ruby string' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_decode
                      end

        option :uudecode, desc: 'uudecodes the data' do
          require 'ronin/support/encoding/uuencoding'
          @method_calls << :uudecode
        end

        option :xml, short: '-x',
                     desc: 'XML decodes the data' do
                       require 'ronin/support/encoding/xml'
                       @method_calls << :xml_decode
                     end

        description 'Decodes each character of data from a variety of encodings'

        man_page 'ronin-decode.1'

      end
    end
  end
end
