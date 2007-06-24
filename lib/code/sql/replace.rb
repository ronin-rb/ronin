module Ronin
  module Code
    module SQL
      class Replace < Command

	def initialize(table=nil,values=nil,from=nil,&block)
	  @table = table
	  @values = values
	  @from = from

	  super("REPLACE",&block)
	end

	def values(data)
	  @values = data
	end

	def from(expr)
	  @from = expr
	end

	def compile(dialect=nil,multiline=false)
	  if @values.kind_of?(Hash)
	    return super('INTO',@table,format_list(@values.keys),'VALUES',format_datalist(@values.values))
	  elsif @from.kind_of?(Select)
	    return super('INTO',@table,format_list(@values),@from)
	  end
	end

      end
    end
  end
end
