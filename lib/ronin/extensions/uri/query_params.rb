#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'cgi'

module URI
  module QueryParams
    # Query parameters
    attr_accessor :query_params

    #
    # Creates a new URI::HTTP object and initializes query_params as a
    # new Hash.
    #
    def initialize(*args)
      @query_params = {}

      super(*args)

      parse_query_params
    end

    #
    # Sets the query string and updates query_params.
    #
    # @param [String] query_str
    #   The new URI query string to use.
    #
    # @return [String]
    #   The new URI query string.
    #
    # @example
    #   url.query = 'a=1&b=2'
    #   # => "a=1&b=2"
    #
    def query=(query_str)
      new_query = super(query_str)
      parse_query_params
      return new_query
    end

    #
    # Iterates over every query parameter.
    #
    # @yield [name, value]
    #   The block to pass each query parameter to.
    #
    # @yieldparam [String] name
    #   The name of the query parameter.
    #
    # @yieldparam [String] value
    #   The value of the query parameter.
    #
    # @example
    #   url.each_query_param do |name,value|
    #     puts "#{name} = #{value}"
    #   end
    #
    def each_query_param(&block)
      @query_params.each(&block)
    end

    protected

    #
    # Parses the query parameters from the query data, populating
    # query_params with the parsed parameters.
    #
    def parse_query_params
      @query_params.clear

      if @query
        @query.split('&').each do |param|
          name, value = param.split('=')

          if value
            @query_params[name] = URI.decode(value)
          else
            @query_params[name] = nil
          end
        end
      end
    end

    private

    def path_query
      str = @path

      unless @query_params.empty?
        str += '?' + @query_params.to_a.map { |name,value|
          if value==true
            "#{name}=active"
          elsif value
            if value.kind_of?(Array)
              "#{name}=#{CGI.escape(value.join(' '))}"
            else
              "#{name}=#{CGI.escape(value.to_s)}"
            end
          else
            "#{name}="
          end
        }.join('&')
      end

      return str
    end
  end
end
