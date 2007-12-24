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

require 'og'
require 'rexml/document'
require 'uri'

module Ronin
  class Author

    ANONYMOUSE = 'anonymous'

    # Name of author
    attr_reader :name, String

    # Author's associated group
    attr_accessor :organization, String

    # Author's PGP signature
    attr_accessor :pgp_signature, String

    # Author's
    attr_accessor :address, String

    # Author's phone
    attr_accessor :phone, String

    # Author's email
    attr_accessor :email, String

    # Author's site
    attr_accessor :site, String

    # Author's biography
    attr_accessor :biography, String

    schema_inheritance

    def initialize(name=ANONYMOUSE,info={:organization=> nil, :pgp_signature => nil, :address => nil, :phone => nil, :email => nil, :site => nil, :biography => nil},&block)
      @name = name
      @organization= info[:organization]
      @pgp_signature = info[:pgp_signature]
      @address = info[:address]
      @phone = info[:phone]
      @email = info[:email]
      @site = info[:site]
      @biography = info[:biography]

      block.call(self) if block
    end

    def to_s
      @name.to_s
    end

    def self.parse_xml(doc,xpath='/ronin/contributors/author')
      authors = []

      doc.elements.each(xpath) do |element|
        author_name = nil
        author_info = {}

        # name of the author
        element.each_element('name') { |name| author_name = name.get_text.to_s }

        # default the name to ANONYMOUSE
        if (author_name.nil? || author_name.empty?)
          author_name = ANONYMOUSE
        end

        # associated group of the author
        element.each_element('group') { |group| author_info[:group] = group.get_text.to_s }

        # the authors PGP signature
        element.each_element('pgp_signature') { |signature| author_info[:pgp_signature] = signature.get_text.to_s }

        # author's contact information
        element.each_element('contact/address') { |address| author_info[:address] = address.get_text.to_s }
        element.each_element('contact/phone') { |phone| author_info[:phone] = phone.get_text.to_s }
        element.each_element('contact/email') { |email| author_info[:email] = email.get_text.to_s }
        element.each_element('contact/site') { |site| author_info[:site] = site.get_text.to_s }

        # author's biography
        element.each_element('biography') { |biography| author_info[:biography] = biography.get_text.to_s }

        authors << Author.new(author_name,author_info)
      end

      return authors
    end

    def to_s
      @name.to_s
    end

  end
end
