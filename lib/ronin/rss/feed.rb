#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  module RSS
    class Feed

      # URL of the feed
      attr_reader :url

      #
      # Creates a new Feed object with the specified _url_.
      #
      def initialize(url)
        @url = URI.parse(url)

        update
      end

      #
      # Returns the title of the feed.
      #
      def title
        @rss.channel.title
      end

      #
      # Returns the link to the feed.
      #
      def link
        @rss.channel.link
      end

      #
      # Returns the description for the feed.
      #
      def description
        @rss.channel.description
      end

      #
      # Returns the date the feed was published.
      #
      def published
        @rss.channel.date
      end

      #
      # Updates the feeds content.
      #
      def update(&block)
        @rss = RSS::Parser.parse(open(@url),false)

        block.call(self) if block
        return self
      end

      #
      # Returns the title of the feed.
      #
      def to_s
        title.to_s
      end

    end
  end
end
