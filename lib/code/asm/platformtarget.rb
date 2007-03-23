require 'platform'
require 'code/asm/archtarget'

module Ronin
  module Asm
    class PlatformTarget < ArchTarget

      # Platform target
      attr_reader :platform

      # Platform syscalls
      attr_reader :syscalls

      def initialize(platform)
	super(platform.arch)
	@platform = platform
	@syscalls = {}
      end

      def has_syscall?(sym)
	@syscalls.has_key?(sym)
      end

      def syscall(sym)
	@syscalls[sym]
      end

      def to_s
	@platform.to_s
      end

    end
  end
end
