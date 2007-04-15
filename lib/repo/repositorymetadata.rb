require 'rexml/document'
require 'open-uri'
require 'uri'

module Ronin
  module Repo
    class RepositoryMetadata

      include REXML

      # Name of the repository
      attr_reader :name

      # Source URI of the repository source
      attr_reader :src

      # Type of repository
      attr_reader :type

      # Authors of the repository
      attr_reader :authors

      # Description
      attr_reader :description

      # Metadata URIs of dependencies
      attr_reader :deps

      def initialize(metadata_uri,&block)
	metadata = Document.new(open(metadata_uri))

	@description = ""
	@deps = {}
	@authors = Author.parse_xml(metadata,'/ronin/repository/authors')

	metadata.elements.each('/ronin/repository') do |repo|
	  repo.each_element('type') { |type| @type = type.get_text.to_s }
	  repo.each_element('src') { |src| @src = URI.parse(src.get_text.to_s) }

	  repo.each_element('description') { |desc| @description = desc.get_text.to_s }

	  repo.each_element('dependency') do |dep|
	    @deps[dep.attribute('name')] = URI.parse(dep.get_text.to_s)
	  end
	end

	block.call(self) if block
      end

      def to_s
	@name
      end

    end
  end
end
