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

require 'rexml/document'
require 'uri'

module Ronin
  class Author

    # Name of author
    attr_reader :name

    # Author's
    attr_reader :address

    # Author's phone
    attr_reader :phone

    # Author's email
    attr_reader :email

    # Author's site
    attr_reader :site

    # Author's biography
    attr_reader :biography

    def initialize(name,biography='',contact={})
      @name = name
      @address = contact[:address]
      @phone = contact[:phone]
      @email = contact[:email]
      @site = contact[:site]
      @biography = biography
    end

    def Author.parse(doc,xpath='/ronin/author')
      authors = {}

      doc.elements.each(xpath) do |element|
	author_name = element.attribute('name').to_s

	if (author_name.nil? || author_name=AUTHOR_NO_ONE.name)
	  authors[AUTHOR_NO_ONE.name] = AUTHOR_NO_ONE
	else
	  author_contact = {}

	  element.each_element('contact/address') { |address| author_contract[:address] = address.get_text.to_s }
	  element.each_element('contact/phone') { |phone| author_contract[:phone] = phone.get_text.to_s }
	  element.each_element('contact/email') { |email| author_contract[:email] = URI.parse(email.get_text.to_s) }
	  element.each_element('contact/site') { |site| author_contract[:site] = URI.parse(site.get_text.to_s) }

	  element.each_element('biography') { |biography| author_biography = biography.get_text.to_s }

	  authors[author_name] = Author.new(author_name,author_biography,author_contract)
	end
      end

      return authors
    end

    def to_s
      @name
    end

  end

  AUTHOR_NO_ONE = Author.new(
    'no-one',
    'A great contributor to culture who wishes to remain anonymous \
    for philosophical and strategic reasons'
  )

end
