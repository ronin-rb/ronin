require 'proto/http'

module Ronin
  module Proto
    module Web
      include HTTP

      protected

      def get_url(url,&block)
	uri = URI.parse(page)
	response = proxify.start(uri.host,uri.port) do |http|
	  http.get(uri.path)
	end

	block.call(response.body) if block
	return response.body
      end

      def post_url(url,post_data,&block)
	response = proxify.post_form(URI.parse(url),post_data)

	block.call(response.body) if block
	return response.body
      end
    end
  end
end
