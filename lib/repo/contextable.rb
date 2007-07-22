require 'extensions/object'
require 'repo/extensions/kernel'
require 'repo/exceptions/contextnotfound'

module Ronin
  module Repo
    module Contextable

      protected

      def Object.define_context(id)
	# define context_type
	meta_def(:context_name) { id }
	class_def(:context_name) { id }
      end

      def Contextable.load_contexts(path)
	unless File.file?(path)
	  raise ContextNotFound, "context '#{path}' doest not exist", caller
	end

	# push on the path to load
	ronin_pending_contexts.unshift(path)

	load(path)

	# pop off the path to load
	ronin_pending_contexts.shift

	# return the loaded contexts
	return ronin_contexts
      end

      def load_context(path)
	block = Contextable.load_contexts(path)[context_name]
	ronin_contexts.clear

	instance_eval(&block) if block
	return self
      end
    end
  end
end
