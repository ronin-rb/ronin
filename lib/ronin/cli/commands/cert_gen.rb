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

require 'ronin/cli/command'
require 'ronin/support/crypto/cert'
require 'ronin/support/text/patterns'

require 'ronin/core/cli/logging'

module Ronin
  class CLI
    module Commands
      #
      # Generates a new X509 certificate.
      #
      # ## Usage
      #
      #     ronin cert-gen [options]
      #
      # ## Options
      #
      #         --version NUM                The certificate version number (Default: 2)
      #         --serial NUM                 The certificate serial number (Default: 0)
      #         --not-before TIME            When the certificate becomes valid. Defaults to the current time.
      #         --not-after TIME             When the certificate becomes no longer valid. Defaults to one year from now.
      #     -c, --common-name DOMAIN         The Common Name (CN) for the certificate
      #     -A, --subject-alt-name HOST|IP   Adds HOST or IP to subjectAltName
      #     -O, --organization NAME          The Organization (O) for the certificate
      #     -U, --organizational-unit NAME   The Organizational Unit (OU)
      #     -L, --locality NAME              The locality for the certificate
      #     -S, --state XX                   The two-letter State (ST) code for the certificate
      #     -C, --country XX                 The two-letter Country (C) code for the certificate
      #     -t, --key-type rsa|ec            The signing key type
      #         --generate-key PATH          Generates and saves a random key (Default: key.pem)
      #     -k, --key-file FILE              Loads the signing key from the FILE
      #     -H sha256|sha1|md5,              The hash algorithm to use for signing (Default: sha256)
      #         --signing-hash
      #         --ca-key FILE                The Certificate Authority (CA) key
      #         --ca-cert FILE               The Certificate Authority (CA) certificate
      #         --ca                         Generates a CA certificate
      #     -o, --output FILE                The output file (Default: cert.crt)
      #     -h, --help                       Print help information
      #
      # ### Examples
      #
      #     ronin cert_gen -c test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US
      #     ronin cert_gen -c test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US --key-file private.key
      #     ronin cert_gen -c test.com -A www.test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US
      #     ronin cert_gen --ca -c "Test CA" -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US
      #     ronin cert_gen -c test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US --ca-key ca.key --ca-cert ca.crt
      #
      class CertGen < Command

        include Core::CLI::Logging

        option :version, value: {
                           type:    Integer,
                           usage:   'NUM',
                           default: 2
                         },
                         desc: 'The certificate version number'

        option :serial, value: {
                          type:    Integer,
                          usage:   'NUM',
                          default: 0
                        },
                        desc: 'The certificate serial number'

        option :not_before, value: {
                              type:  String,
                              usage: 'TIME'
                            },
                            desc: 'When the certificate becomes valid. Defaults to the current time.'

        option :not_after, value: {
                             type:  String,
                             usage: 'TIME'
                           },
                           desc: 'When the certificate becomes no longer valid. Defaults to one year from now.'

        option :common_name, short: '-c',
                             value: {
                               type:  String,
                               usage: 'DOMAIN'
                             },
                             desc: 'The Common Name (CN) for the certificate'

        option :subject_alt_name, short: '-A',
                                  value: {
                                     type:  /[a-z0-9:\._-]+/,
                                     usage: 'HOST|IP'
                                  },
                                  desc: 'Adds HOST or IP to subjectAltName' do |value|
                                    @subject_alt_names << value
                                  end

        option :organization, short: '-O',
                              value: {
                                type:  String,
                                usage: 'NAME'
                              },
                              desc: 'The Organization (O) for the certificate'

        option :organizational_unit, short: '-U',
                                     value: {
                                       type:  String,
                                       usage: 'NAME'
                                     },
                                     desc: 'The Organizational Unit (OU)'

        option :locality, short: '-L',
                          value: {
                            type:  String,
                            usage: 'NAME'
                          },
                          desc: 'The locality for the certificate'

        option :state, short: '-S',
                       value: {
                         type:  String,
                         usage: 'XX'
                       },
                       desc: 'The two-letter State (ST) code for the certificate'

        option :country, short: '-C',
                         value: {
                           type:  String,
                           usage: 'XX'
                         },
                         desc: 'The two-letter Country (C) code for the certificate'

        option :key_type, short: '-t',
                          value: {
                            type: [:rsa, :ec]
                          },
                          desc: 'The signing key type'

        option :generate_key, value: {
                                type:    String,
                                usage:   'PATH',
                                default: 'key.pem'
                              },
                              desc: 'Generates and saves a random key'

        option :key_file, short: '-k',
                          value: {
                            type:  String,
                            usage: 'FILE'
                          },
                          desc: 'Loads the signing key from the FILE'

        option :signing_hash, short: '-H',
                              value: {
                                type: [:sha256, :sha1, :md5],
                                default: :sha256
                              },
                              desc: 'The hash algorithm to use for signing'

        option :ca_key, value: {
                          type:  String,
                          usage: 'FILE'
                        },
                        desc: 'The Certificate Authority (CA) key'

        option :ca_cert, value: {
                           type:  String,
                           usage: 'FILE'
                         },
                         desc: 'The Certificate Authority (CA) certificate'

        option :ca, desc: 'Generates a CA certificate'

        option :output, short: '-o',
                        value: {
                          type:    String,
                          usage:   'FILE',
                          default: 'cert.crt'
                        },
                        desc: 'The output file'

        examples [
          '-c test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US',
          '-c test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US --key-file private.key',
          '-c test.com -A www.test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US',
          '--ca -c "Test CA" -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US',
          '-c test.com -O "Test Co" -U "Test Dept" -L "Test City" -S NY -C US --ca-key ca.key --ca-cert ca.crt'
        ]

        description 'Generates a new X509 certificate'

        man_page 'ronin-cert-gen.1'

        #
        # Initializes the `ronin cert-gen` command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @subject_alt_names = []
        end

        #
        # Runs the `ronin cert-gen` command.
        #
        def run
          if options[:generate_key]
            log_info "Generating new #{options.fetch(:key_type,:rsa).upcase} key ..."
          end

          key  = signing_key
          cert = Ronin::Support::Crypto::Cert.generate(
            version:    options[:version],
            serial:     options[:serial],
            not_before: not_before,
            not_after:  not_after,
            key:        key,
            ca_key:     ca_key,
            ca_cert:    ca_cert,
            subject: {
              common_name:         options[:common_name],
              organization:        options[:organization],
              organizational_unit: options[:organizational_unit],
              locality:            options[:locality],
              state:               options[:state],
              country:             options[:country]
            },
            extensions: extensions
          )

          if options[:generate_key]
            log_info "Saving key to #{options[:generate_key]} ..."
            key.save(options[:generate_key])
          end

          log_info "Saving certificate to #{options[:output]} ..."
          cert.save(options[:output])
        end

        #
        # The parsed `--not-before` time or now.
        #
        # @return [Time]
        #
        def not_before
          @not_before ||= if options[:not_before]
                            Time.parse(options[:not_before])
                          else
                            Time.now
                          end
        end

        #
        # The parsed `--not-after` time or one year from now.
        #
        # @return [Time]
        #
        def not_after
          @not_after ||= if options[:not_after]
                           Time.parse(options[:not_after])
                         else
                           not_before+Support::Crypto::Cert::ONE_YEAR
                         end
        end

        #
        # The `--key-type` key class.
        #
        # @return [Class<Ronin::Support::Key::RSA>,
        #          Class<Ronin::Support::Key::EC>, nil]
        #
        def key_class
          case options[:key_type]
          when :rsa then Support::Crypto::Key::RSA
          when :ec  then Support::Crypto::Key::EC
          end
        end

        #
        # Loads the `--key-file` key file or generates a new signing key.
        #
        # @return [Ronin::Support::Key::RSA, Ronin::Support::Key::EC, nil]
        #
        def signing_key
          if options[:key_file]
            if options[:key_type]
              key_class.load_file(options[:key_file])
            else
              begin
                Support::Crypto::Key.load_file(options[:key_file])
              rescue ArgumentError => error
                print_error(error.message)
                exit(-1)
              end
            end
          else
            (key_class || Support::Crypto::Key::RSA).random
          end
        end

        #
        # Loads the `--ca-key` key file.
        #
        # @return [Ronin::Support::Key::RSA, nil]
        #
        def ca_key
          if options[:ca_key]
            Support::Crypto::Key::RSA.load_file(options[:ca_key])
          end
        end

        #
        # Loads the `--ca-cert` certificate file.
        #
        # @return [Ronin::Support::Crypto::Cert, nil]
        #
        def ca_cert
          if options[:ca_cert]
            Support::Crypto::Cert.load_file(options[:ca_cert])
          end
        end

        #
        # Builds the extensions.
        #
        # @return [Hash{String => Object}, nil]
        #
        def extensions
          exts = {}

          if (ext = basic_constraints_ext)
            exts['basicConstraints'] = ext
          end

          if (ext = subject_alt_name_ext)
            exts['subjectAltName'] = ext
          end

          exts unless exts.empty?
        end

        #
        # Builds the `basicConstraints` extension.
        #
        # @return [(String, Boolean), nil]
        #
        def basic_constraints_ext
          if options[:ca]
            ['CA:TRUE', true]
          elsif options[:ca_key] || options[:ca_cert]
            ['CA:FALSE', true]
          end
        end

        IP_REGEXP = Support::Text::Patterns::IP

        #
        # Builds the `subjectAltName` extension.
        #
        # @return [String, nil]
        #
        def subject_alt_name_ext
          if !@subject_alt_names.empty?
            @subject_alt_names.map { |name|
              if name =~ IP_REGEXP
                "IP: #{name}"
              else
                "DNS: #{name}"
              end
            }.join(', ')
          end
        end

      end
    end
  end
end
