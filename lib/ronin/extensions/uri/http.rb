#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/extensions/uri/query_params'
require 'ronin/extensions/hash'

require 'uri/http'

module URI
  class HTTP < Generic

    include QueryParams

    #
    # Explodes the HTTP URI query_params into a Hash of HTTP URIs using the
    # given _options_, where each HTTP URI has the value of one of the
    # query_params replaced with the specified _value_. If a _block_ is
    # given, it will be passed each query_param and the resulting HTTP URI.
    #
    #   url = URI('http://search.dhgate.com/search.do?dkp=1&searchkey=yarn&catalog=')
    #   url.explode_query_params("'")
    #   # => {"searchkey"=>#<URI::HTTP:0xfdb915e82 URL:http://search.dhgate.com/search.do?searchkey='&catalog=&dkp=1>, 
    #   # "catalog"=>#<URI::HTTP:0xfdb915e6e URL:http://search.dhgate.com/search.do?searchkey=yarn&catalog='&dkp=1>,
    #   # "dkp"=>#<URI::HTTP:0xfdb915e5a URL:http://search.dhgate.com/search.do?searchkey=yarn&catalog=&dkp='>}
    #
    def explode_query_params(value,options={},&block)
      urls = {}

      @query_params.explode(value,options).each do |param,params|
        new_url = clone
        new_url.query_params = params

        block.call(param,new_url) if block
        urls[param] = new_url
      end

      return urls
    end

    #
    # Explodes the HTTP URI's query_params using the given _options_ and
    # builds a Hash of return-values generated from calling the specified
    # _block_ with each exploded HTTP URI.
    #
    def test_query_params(value,options={},&block)
      results = {}

      explode_query_params(value,options) do |url|
        result = block.call(param,url)

        results[param] = result if result
      end

      return results
    end

  end
end
