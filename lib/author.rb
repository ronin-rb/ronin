require 'rexml/element'
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

    def parse_xml(doc,xpath)
      authors = {}

      doc.elements.each(xpath+'/author') do |element|
	author_name = element.attribute('name')

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
