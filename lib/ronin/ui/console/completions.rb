#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/address'
require 'ronin/ip_address'
require 'ronin/host_name'
require 'ronin/email_address'
require 'ronin/url'

require 'ripl'
require 'ripl/completion'

module Ronin
  module UI
    module Console
      #
      # Adds a tab-completion rule to the Console.
      #
      # @param [Hash] options
      #   Pattern matching options.
      #
      # @yield [(match)]
      #   The given block will be passed the matched pattern,
      #   and will return an Array of possible completions.
      #
      # @yieldparam [String] match
      #   The pattern match.
      #
      # @return [true]
      #   Specifies whether the complete rule was successfully added.
      #
      # @since 1.2.0
      #
      # @api semipublic
      #
      def Console.complete(options,&block)
        Ripl::Completion.complete(options,&block)
      end

      #
      # {URL} completion in the context of URLs.
      #
      # 
      #     http://www.example.com/in[TAB][TAB] => http://www.example.com/index.html
      #
      Console.complete(:anywhere => /[a-z]+:\/\/([^:\/\?]+(:\d+)?(\/[^\?;]*(\?[^\?;]*)?)?)?/) do |url|
        match = url.match(/([a-z]+):\/\/([^:\/\?]+)(:\d+)?(\/[^\?;]*)?(\?[^\?;]*)?/)

        query = URL.all('scheme.name' => match[1])

        if match[2]
          unless (match[4] || match[3])
            query = query.all('host_name.address.like' => "#{match[2]}%")
          else
            query = query.all('host_name.address' => match[2])
          end
        end

        if match[3]
          query = query.all('port.number' => match[3])
        end

        if match[4]
          unless match[5]
            query = query.all(:path.like => "#{match[4]}%")
          else
            query = query.all(:path => match[4])
          end
        end

        if match[5]
          params = URI::QueryParams.parse(match[5][1..-1]).to_a
          
          params[0..-2].each do |name,value|
            query = query.all(
              'query_params.name.name' => name,
              'query_params.value' => value
            )
          end

          if (param = params.last)
            if param[1].empty?
              query = query.all('query_params.name.name.like' => "#{param[0]}%")
            else
              query = query.all(
                'query_params.name.name' => param[0],
                'query_params.value.like' => "#{param[1]}%"
              )
            end
          end
        end

        query
      end

      #
      # {IPAddress} completion:
      #
      #     192.168.[TAB][TAB] => 192.168.0.1
      #
      Console.complete(:anywhere => /(\d{1,3}\.){1,3}\d{,2}/) do |addr|
        Address.all(:address.like => "#{addr}%")
      end

      #
      # {HostName} completion:
      #
      #     www.[TAB][TAB] => www.example.com
      #
      Console.complete(:anywhere => /[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]*/) do |host|
        HostName.all(:address.like => "#{host}%")
      end

      #
      # {EmailAddress} completeion:
      #
      #     alice@[TAB][TAB] => alice@example.com
      #
      Console.complete(:anywhere => /[a-zA-Z0-9\._-]+@[a-zA-Z0-9\._-]*/) do |email|
        user, host = email.split('@',2)

        EmailAddress.all(
          'user_name.name' => user,
          'host_name.address.like' => "#{host}%"
        )
      end

      #
      # Path completion.
      #
      #     /etc/pa[TAB][TAB] => /etc/passwd
      #
      Console.complete(:anywhere => /\/([^\/]+\/)*[^\/]*/) do |path|
        Dir["#{path}*"]
      end
    end
  end
end
