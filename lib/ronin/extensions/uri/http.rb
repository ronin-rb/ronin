#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'uri/http'

module URI
  class HTTP < Generic

    # Query parameters
    attr_reader :query_params

    alias_method :old_initialize, :initialize

    #
    # Creates a new URI::HTTP object and initializes query_params as a
    # new Hash.
    #
    def initialize(*args)
      old_initialize(*args)

      @query_params = {}
      parse_query_params
    end

    #
    # Sets the query data and updates query_params.
    #
    def query=(query_str)
      new_query = super(query_str)
      parse_query_params
      return new_query
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

    # :nodoc
    def path_query
      str = @path

      unless @query_params.empty?
        str += '?' + @query_params.to_a.map { |name,value|
          if value==true
            "#{name}=active"
          elsif value
            if value.kind_of?(Array)
              "#{name}=#{URI.encode(value.join(' '))}"
            else
              "#{name}=#{URI.encode(value.to_s)}"
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
