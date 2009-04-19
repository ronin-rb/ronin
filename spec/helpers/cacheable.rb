require 'classes/cacheable_model'

require 'tmpdir'
require 'fileutils'

CACHED_PATH = File.expand_path(File.join(File.dirname(__FILE__),'contexts','ronin_cacheable_model.rb'))
