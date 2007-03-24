require 'code/codetarget'
require 'code/librarytarget'

module Ronin
  module Code
    class ProgramState

      # Instruction pointer
      attr_reader :ip

      # Stack pointer
      attr_reader :sp

      # Stack base
      attr_reader :bp

      def initialize(ip,sp,bp=sp)
	@ip = ip
	@sp = sp
	@bp = bp
      end

    end

    class ProgramTarget < CodeTarget

      # Provided libraries
      attr_reader :libs

      # Program state
      attr_reader :state

      def initialize(name,ro,data,text,state,variables={},funcs={},libs={})
	super(name,ro,data,text,variables,funcs)
	@libs = libs
	@state = state
      end

      def has_variable?(sym,context=nil)
	if context
	  if context==@name
	    return CodeTarget::has_variable?(sym)
	  else
	    return @libs[context].has_variable?(sym)
	  end
	else
	  return true if CodeTarget::has_variable?(sym)

	  @libs.each_value do |lib|
	    return true if lib.has_variable?(sym)
	  end
	  return false
	end
      end

      def variable(sym,context=nil)
	if context
	  if context==@name
	    return CodeTarget::variable(sym)
	  else
	    return @libs[context].variable(sym)
	  end
	else
	  return CodeTarget::variable(sym) if CodeTarget::has_variable?(sym)

	  @libs.each_value do |lib|
	    return lib.variable(sym) if lib.has_variable?(sym)
	  end
	  return nil 
	end
      end

      def has_function?(sym,context=nil)
	if context
	  if context==@name
	    return CodeTarget::has_function?(sym)
	  else
	    return @libs[context].has_function?(sym)
	  end
	else
	  return true if CodeTarget::has_function?(sym)

	  @libs.each_value do |lib|
	    return true if lib.has_function?(sym)
	  end
	  return false
	end
      end

      def function(sym,context=nil)
	if context
	  if context==@name
	    return CodeTarget::function(sym)
	  else
	    return @libs[context].function(sym)
	  end
	else
	  return CodeTarget::function(sym) if CodeTarget::has_function?(sym)

	  @libs.each_value do |lib|
	    return lib.function(sym) if lib.has_function?(sym)
	  end
	  return nil 
	end
      end

    end
  end
end
