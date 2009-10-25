require 'ronin/static'

module Helpers
  STATIC_DIRS = [
    File.expand_path(File.join(File.dirname(__FILE__),'static1')),
    File.expand_path(File.join(File.dirname(__FILE__),'static2')),
  ]

  STATIC_DIRS.each { |dir| Ronin::Static.directory(dir) }
end
