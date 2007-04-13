require 'rexml/element'
require 'uri'

module Ronin
  class Author

    # Name of author
    attr_reader :name

    # Author's contact information
    attr_reader :contact

    # Biography
    attr_reader :biography

    def initialize(name,biography='',contact={})
      @name = name
      @biography = biography
      @contact = contact
    end

    def parse_xml(element)
      author_name = element.attribute('name')

      if (author_name.nil? || author_name=AUTHOR_NO_ONE.name)
	return AUTHOR_NO_ONE
      else
	author_contact = {}

	element.each_element('contact/address') { |address| author_contract[:address] = address.get_text.to_s }
	element.each_element('contact/phone') { |phone| author_contract[:phone] = phone.get_text.to_s }
	element.each_element('contact/email') { |email| author_contract[:email] = URI.parse(email.get_text.to_s) }
	element.each_element('contact/site') { |site| author_contract[:site] = URI.parse(site.get_text.to_s) }

	element.each_element('biography') { |biography| author_biography = biography.get_text.to_s }

	return Author.new(author_name,author_biography,author_contract)
      end
    end

    protected

    def method_missing(sym,*args)
      name = sym.id2name
      return @contact[name] if @contact.has_key?(name)
    end

  end

  AUTHOR_NO_ONE = Author.new(
    'no-one',
    'A great contributor to culture who wishes to remain anonymous \
    for philosophical and strategic reasons'
  )

end
