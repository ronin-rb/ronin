#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'rss/parser'
require 'open-uri'

module Ronin
  module Advisories
    class Feed

      # Title of the feed
      attr_reader :title

      # Link of the feed
      attr_reader :link

      # Description of the feed
      attr_reader :description

      # Publish date of the feed
      attr_reader :published

      # URL of the feed
      attr_reader :url

      def initialize(url)
        @url = URI.parse(url)

        update
      end

      def update
        @rss = RSS::Parser.parse(open(@url),false)
        @title = @rss.channel.title
        @link = @rss.channel.link
        @description = @rss.channel.description
        @published = @rss.channel.date
      end

      def to_s
        @title.to_s
      end

    end
  end
end
