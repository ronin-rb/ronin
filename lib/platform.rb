require 'arch'

module Ronin
  class Platform

    # Name of the Operating System
    attr_reader :os

    # Version of the Operating System
    attr_reader :version

    # Architecture of the Platform
    attr_reader :arch

    def initialize(os,version,arch)
      @os = os
      @version = version
      @arch = arch
    end

  end

  class Linux < Platform

    def initialize(version,arch)
      super("Linux",version,arch)
    end

  end

  class FreeBSD < Platform

    def initialize(version,arch)
      super("FreeBSD",version,arch)
    end

  end

  class OpenBSD < Platform

    def initialize(version,arch)
      super("OpenBSD",version,arch)
    end

  end

  class NetBSD < Platform

    def initialize(version,arch)
      super("NetBSD",version,arch)
    end

  end

  class Windows < Platform

    def initialize(version,arch)
      super("Windows",version,arch)
    end

  end

  class OSX < Platform

    def initialize(version,arch)
      super("OSX",version,arch)
    end

  end
end
