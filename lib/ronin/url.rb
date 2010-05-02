#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/host_name'
require 'ronin/tcp_port'
require 'ronin/site_credential'
require 'ronin/comment'
require 'ronin/model'

require 'dm-timestamps'
require 'dm-tags'
require 'uri'

module Ronin
  class URL

    include Model
    include DataMapper::Timestamps

    # Primary key of the URL
    property :id, Serial

    # Scheme of the URL
    property :scheme, String, :set => ['http', 'https'],
                              :required => true

    # The host name of the URL
    belongs_to :host_name

    # Port of the URL
    belongs_to :port, :model => 'TCPPort'

    # Path of the URL
    property :path, String, :default => ''

    # Query string of the URL
    property :query_string, String

    # The fragment of the URL
    property :fragment, String

    # Any credentials used with the URL
    has 0..n, :site_credentials

    # Comments on the URL
    has 0..n, :comments

    # Defines the created_at timestamp
    timestamps :created_at

    # Tags
    has_tags_on :tags

    #
    # Parses the URL.
    #
    # @param [String] url
    #   The raw URL to parse.
    #
    # @return [URL]
    #   The parsed URL.
    #
    # @since 0.4.0
    #
    def URL.parse(url)
      uri = ::URI.parse(url)

      return URL.new(
        :scheme => uri.scheme,
        :host_name => HostName.first_or_new(:address => uri.host),
        :port => TCPPort.first_or_new(:number => uri.port),
        :path => uri.path,
        :query_string => uri.query,
        :fragment => uri.fragment
      )
    end

    #
    # The host name of the url.
    #
    # @return [String]
    #   The address of host name.
    #
    def host
      self.host_name.address
    end

    #
    # Builds a URI object from the url.
    #
    # @return [URI::HTTP, URI::HTTPS]
    #   The URI object created from the url attributes.
    #
    def to_uri
      url_class = if self.scheme == 'https'
                    URI::HTTPS
                  else
                    URI::HTTP
                  end

      return url_class.build(
        :host => self.host,
        :port => self.port,
        :path => self.path,
        :query => self.query_string
      )
    end

    #
    # Converts the url to a String.
    #
    # @return [String]
    #   The string form of the url.
    #
    def to_s
      self.to_url.to_s
    end

  end
end
