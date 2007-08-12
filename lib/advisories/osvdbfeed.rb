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

require 'advisories/feed'
require 'advisories/osvdb'

module Ronin
  module Advisories
    class OSVDBFeed < Feed

      include Enumerable

      def initialize(url,&block)
	super(url)

	@osvdb_cache = Hash.new { |hash,key| hash[key.to_i] = OSVDB.new(key) }

	black.call(self) if block
      end

      def [](index)
	if index.is_a?(Integer)
	  return advisory_from_link(@rss.items[index.to_i].link)
	elsif index.is_a?(Range)
	  return @rss.items[index].map { |item| advisory_from_link(item.link) }
	elsif (index.is_a?(String) || index.is_a?(Regexp))
	  pattern = Regexp.new(index)
	  return @rss.items.select { |item| item.title =~ pattern }.map { |item| advisory_from_link(item.link) }
	end
      end

      def each(&block)
	@rss.items.each do |item|
	  block.call(advisory_from_link(item.link))
	end
	return self
      end

      protected

      def advisory_from_link(link)
	@osvdb_cache[link[/[[:digit:]]+$/].to_i]
      end

    end
  end
end
