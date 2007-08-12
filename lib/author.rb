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

require 'objectcache'

require 'rexml/document'
require 'uri'

module Ronin
  class Author

    # Name of author
    attr_reader :name, String

    # Author's
    attr_reader :address, String

    # Author's phone
    attr_reader :phone, String

    # Author's email
    attr_reader :email, String

    # Author's site
    attr_reader :site, String

    # Author's biography
    attr_reader :biography, String

    def initialize(name,biography=nil,info={:address => nil, :phone => nil, :email => nil, :site => nil})
      @name = name
      @address = info[:address]
      @phone = info[:phone]
      @email = info[:email]
      @site = info[:site]
      @biography = biography
    end

    def self.parse(doc,xpath='/ronin/author')
      authors = []

      doc.elements.each(xpath) do |element|
	author_name = element.attribute('name').to_s

	unless (author_name.empty? || author_name=NO_ONE.name)
	  author_info = {}

	  element.each_element('contact/address') { |address| author_contract[:address] = address.get_text.to_s }
	  element.each_element('contact/phone') { |phone| author_contract[:phone] = phone.get_text.to_s }
	  element.each_element('contact/email') { |email| author_contract[:email] = URI.parse(email.get_text.to_s) }
	  element.each_element('contact/site') { |site| author_contract[:site] = URI.parse(site.get_text.to_s) }

	  element.each_element('biography') { |biography| author_biography = biography.get_text.to_s }

	  authors << Author.new(author_name,author_biography,author_contract)
	end
      end

      return authors
    end

    def to_s
      @name.to_s
    end

  end
end
