require 'audit/report'

module Ronin
  module Audit
    module Web
      module SQL
	class SQLRecord < Report

	  # URL that was injected
	  attr_accessor :url

	  # Parameters of the URL
	  attr_accessor :params

	  # Parameters that where injected
	  attr_accessor :injection_params

	  # Injectable parameters
	  attr_accessor :injectable_params

	  # Was the URL accessed via GET or POST
	  attr_accessor :post

	  def initialize(url,params,injection_params,post)
	    @params = {}
	    @injection_params = []
	    @injectable_params = []
	    @post = false
	  end

	end
      end
    end
  end
end
