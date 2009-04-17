require 'ronin/static'

STATIC_DIRS = [
  File.expand_path(File.join(File.dirname(__FILE__),'static1')),
  File.expand_path(File.join(File.dirname(__FILE__),'static2')),
]

module Ronin
  STATIC_DIRS.each { |dir| Static.directory(dir) }
end
