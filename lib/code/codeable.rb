module Ronin
  module Code
    module Codeable

      protected

      def Object.flag(*ids)
	for id in ids
	  class_eval <<-end_eval
	    def #{id}
	      @#{id} = true
	      return self
	    end

	    protected

	    def #{id}?
	      return "#{id.to_s.capitalize}" if @#{id}
	    end
	  end_eval
	end
      end

      def Object.option(id,value=nil)
	class_eval <<-end_eval
	  def #{id}
	    @#{id} = true
	    return self
	  end
	end_eval

	if value
	  class_eval <<-end_eval
	    protected

	    def #{id}?
	      "#{value}" if @#{id}
	    end
	  end_eval
	end
      end

      def Object.option_list(id,values=[])
	values.each do |opt|
	  class_eval <<-end_eval
	    def #{opt}
	      @#{id} = "#{opt.to_s.capitalize}"
	    end
	  end_eval
	end

	class_eval <<-end_eval
	  def #{id}?
	    @#{id}
	  end
	end_eval
      end
    end
  end
end
