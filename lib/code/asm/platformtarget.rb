require 'platform'

module Ronin
  module Asm
    class PlatformTarget

      # Platform target
      attr_reader :platform

      # Platform syscalls
      attr_reader :syscalls

      def initialize(platform)
	@platform = platform
	@syscalls = {}
      end

      def has_syscall?(sym)
	return false unless @syscalls.has_key?(@platform.arch.name)
	return @syscalls[@platform.arch.name].has_key?(sym)
      end

      def syscall(sym)
	@syscalls[@platform.arch.name][sym]
      end

      def to_s
	@platform.to_s
      end

    end
  end
end
