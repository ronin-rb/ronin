require 'author'
require 'repo/objectmetadata'

module Ronin
  module Repo
    class AuthorContext

      # Name of author
      attr_reader :name

      def initialize(name,&block)
	@name = name.to_s

	# initialize author metadata
	metadata_set(:address)
	metadata_set(:phone)
	metadata_set(:email)
	metadata_set(:site)
	metadata_set(:biography,"")

	instance_eval(&block) if block
      end

      def to_author
	Author.new(@name,biography,{:address => address, :phone => phone, :email => email, :site => site})
      end

      protected

      include ObjectMetadata

      # Author's address
      attr_metadata :address

      # Author's phone
      attr_metadata :phone

      # Author's email
      attr_metadata :email

      # Author's site
      attr_metadata :site

      # Authors biography
      attr_metadata :biography

    end
  end
end
