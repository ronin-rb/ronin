require 'audit/web/sql/sqlreport'

module Ronin
  module Audit
    module Web
      module SQL
	class ErrorReport < SQLReport

	  # Targeted platform
	  attr_accessor :platform

	  # Injection string
	  attr_accessor :injection

	  def initialize(platform,injection,url,params,injection_params,post)
	    super(url,params,injection_params,post)

	    @platform = platform
	    @injection = injection
	  end

	end
      end
    end
  end
end
