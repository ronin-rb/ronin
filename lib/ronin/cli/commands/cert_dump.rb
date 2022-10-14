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

require 'ronin/cli/value_processor_command'
require 'ronin/support/crypto/cert'
require 'ronin/support/network/ssl/mixin'

require 'command_kit/printing/indent'
require 'command_kit/printing/fields'
require 'command_kit/printing/lists'

require 'uri'

module Ronin
  class CLI
    module Commands
      #
      # Prints information for SSL/TLS certificates.
      #
      # ## Usage
      #
      #     ronin cert-dump [options] {HOST:PORT | URL | FILE} ...
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #     -C, --common-name                Only prints the Common Name (CN)
      #     -A, --subject-alt-names          Only prints the subjectAltNames
      #     -E, --extensions                 Print all certificate extensions
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     HOST:PORT | URL | FILE ...       A HOST:PORT, URL, or cert FILE
      #
      # ## Examples
      #
      #     ronin cert-dump ssl.crt
      #     ronin cert-dump github.com:443
      #     ronin cert-dump https://github.com/
      #     ronin cert-dump -C 93.184.216.34:443
      #     ronin cert-dump -A wired.com:443
      #
      class CertDump < ValueProcessorCommand

        include Support::Network::SSL::Mixin
        include CommandKit::Printing::Indent
        include CommandKit::Printing::Fields
        include CommandKit::Printing::Lists

        usage '[options] {HOST:PORT | URL | FILE} ...'

        option :common_name, short: '-C',
                             desc:  'Only prints the Common Name (CN)'

        option :subject_alt_names, short: '-A',
                                   desc:  'Only prints the subjectAltNames'

        option :extensions, short: '-E',
                            desc: 'Print all certificate extensions'

        argument :target, required: true,
                          repeats:  true,
                          usage:   'HOST:PORT | URL | FILE',
                          desc:    'A HOST:PORT, URL, or cert FILE'

        description "Prints SSL/TLS certificate information"

        examples [
          'ssl.crt',
          'github.com:443',
          'https://github.com/',
          '-C 93.184.216.34:443',
          '-A wired.com:443'
        ]

        man_page 'ronin-cert-dump.1'

        #
        # Runs the `ronin cert-dump` command.
        #
        # @param [String] value
        #   The `HOST:PORT`, `URL`, or `FILE` value to process.
        #
        def process_value(value)
          case value
          when /\A[^:]+:\d+\z/
            host, port = value.split(':',2)
            port = port.to_i

            print_cert(ssl_cert(host,port))
          when /\Ahttps:/
            uri = URI.parse(value)
            host = uri.host
            port = uri.port

            print_cert(ssl_cert(host,port))
          else
            unless File.file?(value)
              print_error "no such file or directory: #{value}"
              exit(1)
            end

            cert = Support::Crypto::Cert.load_file(value)

            print_cert(cert)
          end
        end

        #
        # Prints the certificate.
        #
        # @param [Ronin::Support::Crypto::Cert] cert
        #
        def print_cert(cert)
          if options[:common_name]
            puts "#{cert.common_name}"
          elsif options[:subject_alt_names]
            if (alt_names = cert.subject_alt_names)
              alt_names.each { |name| puts name }
            end
          else
            print_full_cert(cert)
          end
        end

        #
        # Prints the full verbose information about the certificate.
        #
        # @param [Ronin::Support::Crypto::Cert] cert
        #
        def print_full_cert(cert)
          fields = {}

          fields["Serial"]     = cert.serial
          fields["Version"]    = cert.version
          fields["Not Before"] = cert.not_before if cert.not_before
          fields["Not After"]  = cert.not_after  if cert.not_after
          print_fields(fields)
          puts

          print_public_key(cert.public_key)
          puts

          puts "Subject:"
          indent do
            print_cert_name(cert.subject)

            if (alt_names = cert.subject_alt_names)
              puts "Alt Names:"
              puts

              indent do
                alt_names.each { |name| puts name }
              end
            end
          end

          puts

          puts "Issuer:"
          indent do
            print_cert_name(cert.issuer)
          end

          puts

          fields = {}

          if options[:extensions]
            puts "Extensions:"
            indent do
              print_extensions(cert)
            end
          end
        end

        #
        # Prints the public key.
        #
        # @param [OpenSSL::PKey::RSA, OpenSSL::PKey::EC] public_key
        #
        def print_public_key(public_key)
          puts "Public Key:"

          indent do
            fields = {}

            case public_key
            when OpenSSL::PKey::RSA
              fields['Type'] = 'RSA'
            when OpenSSL::PKey::EC
              fields['Type'] = 'EC'
            end

            print_fields(fields)

            public_key.to_text.each_line do |line|
              puts line
            end
          end
        end

        #
        # Prints the X509 name.
        #
        # @param [Ronin::Support::Crypto::Cert::Name] name
        #
        def print_cert_name(name)
          fields = {}

          if name.common_name
            fields["Common Name"] = name.common_name
          end

          if name.organization
            fields["Organization"] = name.organization
          end

          if name.organizational_unit
            fields["Organizational Unit"] = name.organizational_unit
          end

          if name.locality
            fields["Locality"] = name.locality
          end

          if name.state
            fields["State"] = name.state
          end

          if name.country
            fields["Country"] = name.country
          end

          print_fields(fields)
        end

        #
        # Prints the certificates extensions.
        #
        # @param [Ronin::Support::Crypto::Cert] cert
        #
        def print_extensions(cert)
          cert.extensions.each_with_index do |ext,index|
            puts if index > 0

            print_extension(ext)
          end
        end

        #
        # Prints a certificate extension.
        #
        # @param [OpenSSL::X509::Extension] ext
        #
        def print_extension(ext)
          puts "#{ext.oid}:"

          indent do
            ext.value.each_line do |line|
              puts line
            end
          end
        end

      end
    end
  end
end
