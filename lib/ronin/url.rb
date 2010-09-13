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

require 'ronin/url_scheme'
require 'ronin/host_name'
require 'ronin/tcp_port'
require 'ronin/web_credential'
require 'ronin/comment'
require 'ronin/model'

require 'dm-timestamps'
require 'dm-tags'
require 'uri'
require 'uri/query_params'

module Ronin
  class URL

    include Model
    include DataMapper::Timestamps

    # Mapping of URL Schemes and URI classes
    SCHEMES = {
      'https' => ::URI::HTTPS,
      'http' => ::URI::HTTP,
      'ftp' => ::URI::FTP
    }

    # Primary key of the URL
    property :id, Serial

    # The scheme of the URL
    belongs_to :scheme, :model => 'URLScheme'

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
    has 0..n, :web_credentials

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
        :scheme => URLScheme.first_or_new(:name => uri.scheme),
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
    # @since 0.4.0
    #
    def host
      self.host_name.address
    end

    #
    # The port number used by the URL.
    #
    # @return [Integer]
    #   The port number.
    #
    # @since 0.4.0
    #
    def port_number
      self.port.number
    end

    #
    # The query params of the URL.
    #
    # @return [Hash{String => String}]
    #   The query params of the URL.
    #
    # @since 0.4.0
    #
    def query_params
      @query_params ||= URI::QueryParams.parse(self.query_string)
    end

    #
    # Builds a URI object from the url.
    #
    # @return [URI::HTTP, URI::HTTPS]
    #   The URI object created from the url attributes.
    #
    # @since 0.4.0
    #
    def to_uri
      url_class = (SCHEMES[self.scheme.name] || ::URI::Generic)

      host = if self.host_name
               self.host_name.address
             end
      port = if self.port
               self.port.number
             end

      return url_class.build(
        :scheme => self.scheme.name,
        :host => host,
        :port => port,
        :path => self.path,
        :query => self.query_string,
        :fragment => self.fragment
      )
    end

    #
    # Converts the url to a String.
    #
    # @return [String]
    #   The string form of the url.
    #
    # @since 0.4.0
    #
    def to_s
      self.to_uri.to_s
    end

  end
end
