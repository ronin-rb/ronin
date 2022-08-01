#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
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

require 'ronin/cli/string_command'

require 'ronin/support/network/email_address'

module Ronin
  class CLI
    module Commands
      #
      # Processes email addresses.
      #
      # ## Usage
      #
      #     ronin email-addr [options] [EMAIL_ADDR ...]
      #
      # ## Options
      #
      #     -i, --input FILE                 Optional input file
      #     -O, --obfuscate                  Obfuscates the email address(es)
      #         --enum-obfuscations          Enumerate over every obfuscation
      #     -D, --deobfuscate                Deobfuscates the email address(es)
      #     -n, --name                       Extracts the name part of the email address(es)
      #     -m, --mailbox                    Extracts the mailbox part of the email address(es)
      #     -d, --domain                     Extracts the domain part of the email address(es)
      #     -N, --normalize                  Normalizes the email address(es)
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [EMAIL_ADDR ...]                 The email address(es) to process
      #
      # ## Examples
      #
      #     ronin email-addr --deobfuscate "john{DOT}smith{AT}example{DOT}com"
      #     ronin email-addr --input emails.txt --domain
      #
      class EmailAddr < Command

        include CommandKit::Options::Input

        command_name 'email-addr'

        usage '[options] [EMAIL_ADDR ...]'

        option :obfuscate, short: '-O',
                           desc:  'Obfuscates the email address(es)'

        option :enum_obfuscations, desc: 'Enumerate over every obfuscation'

        option :deobfuscate, short: '-D',
                             desc:  'Deobfuscates the email address(es)'

        option :name, short: '-n',
                      desc:  'Extracts the name part of the email address(es)'

        option :mailbox, short: '-m',
                         desc: 'Extracts the mailbox part of the email address(es)'

        option :domain, short: '-d',
                        desc: 'Extracts the domain part of the email address(es)'

        option :normalize, short: '-N',
                           desc: 'Normalizes the email address(es)'

        argument :email_addr, required: false,
                              repeats:  true,
                              desc:     'The email address(es) to process'

        description "Processes email addresses"

        examples [
          '--deobfuscate "john{DOT}smith{AT}example{DOT}com"',
          '--input emails.txt --domain'
        ]

        man_page 'ronin-email-addr.1'

        #
        # Runs the `ronin email-addr` command.
        #
        # @param [Array<String>] email_addrs
        #   Optional list of email address arguments.
        #
        def run(*email_addrs)
          if !email_addrs.empty?
            email_addrs.each(&method(:process_email_addr))
          elsif !input_files.empty?
            open_input_stream(*input_files) do |input|
              input.each_line(chomp: true, &method(:process_email_addr))
            end
          end
        end

        #
        # Processes an individual email address.
        #
        # @parma [String] string
        #   An individual email address.
        #
        def process_email_addr(string)
          if options[:deobfuscate]
            string = Support::Network::EmailAddress.deobfuscate(string)
          end

          email_address = Support::Network::EmailAddress.parse(string)
          email_address = email_address.normalize if options[:normalize]

          if options[:enum_obfuscations]
            email_address.each_obfuscation do |obfuscated_email|
              puts obfuscated_email
            end
          elsif options[:obfuscate]
            puts email_address.obfuscate
          elsif options[:name]
            puts email_address.name
          elsif options[:mailbox]
            puts email_address.mailbox
          elsif options[:domain]
            puts email_address.domain
          else
            puts email_address
          end
        end

      end
    end
  end
end
