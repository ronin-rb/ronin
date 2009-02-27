require 'ronin/static'
require 'static/helpers/static_class'

STATIC_DIRS = [
  File.expand_path(File.join(File.dirname(__FILE__),'static1')),
  File.expand_path(File.join(File.dirname(__FILE__),'static2')),
]

module Ronin
  STATIC_DIRS.each { |dir| Static.directory(dir) }
end
