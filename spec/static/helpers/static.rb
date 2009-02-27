require 'ronin/static'

STATIC_DIR = File.expand_path(File.join(File.dirname(__FILE__),'static'))

module Ronin
  Static.directory(STATIC_DIR)
end
