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

require 'advisories/advisory'

require 'hpricot'
require 'open-uri'

module Ronin
  module Advisories
    class OSVDB < Advisory

      include Comparable

      # Source of this type of advisory
      SOURCE_NAME = 'OSVDB'

      # Link to the advisory
      attr_reader :link, String

      def initialize(name,&block)
	name = name.to_i
	super(SOURCE_NAME,name)

	@link = URI.parse("http://osvdb.org/displayvuln.php?osvdb_id=#{@name}")
	update

	block.call(self) if block
      end

      def update
	doc = Hpricot(open(@link))
	advisory_table = (doc/'td.mainbodycell/table[2]')

	@title = (doc/'td.mainbodycell/table.sectiondiv_table//font.sectiondiv_header').text.strip

	published_cell = (advisory_table/'tr[2]/td')
	(published_cell/'b').remove

	@published = Date.parse((advisory_table/'tr[2]/td').text.split(':')[1].strip)
	@description = (advisory_table/'tr[3]/td/p').text.strip

	@classification.clear
	@requirements.clear
	@effects.clear

	(advisory_table/'tr[4]/td/ul/li').each do |attributes|
	end

	@products.clear
	(advisory_table/'tr[5]/td/ul/li').each do |product|
	  vendor_link = (product/'a')
	  vendor_name = vendor_link.first.innerText.strip

	  vendor_link.remove
	  product_name = product.innerText.strip
	end

	@solution = (advisory_table/'tr[6]/td/p').text.strip

	@credits.clear

	(advisory_table/'tr[8]/td/ul/li/a').each do |credit|
	  @credits << credit.innerText.strip
	end
      end

      def <=>(other)
	@name<=>other.name
      end

      def to_s
	"#{super}: #{@title}"
      end

    end
  end
end
