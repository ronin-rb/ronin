module Ronin
  module Repo
    class ObjectTemplate

      def initialize(fields={})
	@fields = fields
      end

      def method_missing(sym,*args)
	name = sym.id2name

	# return the field if present
	return @fields[name] if @fields.has_key?(name)

	# raise error, otherwise
	raise NoMethodError.new(name)
      end

    end
  end
end
