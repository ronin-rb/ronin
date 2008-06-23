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

require 'uri/http'

module URI
  class HTTP < Generic

    include QueryParams

    def explode_query_params(value,options={},&block)
      included = (options[:included] || @query_params.keys)
      excluded = (options[:excluded] || [])
      selected_params = included - excluded

      urls = {}
      
      selected_params.each do |key|
        new_url = URI(to_s)
        new_url.query_params[key] = value

        urls[key] = new_url
      end

      urls.each(&block) if block
      return urls
    end

    def test_query_params(value,options={},&block)
      results = {}

      explode_query_params(value,options) do |param,url|
        result = block.call(url)

        results[param] = result if result
      end

      return results
    end

  end
end
