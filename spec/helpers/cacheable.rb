require 'classes/cacheable_model'

require 'tmpdir'
require 'fileutils'

CACHED_FILE = File.expand_path(File.join(File.dirname(__FILE__),'contexts','ronin_cacheable_model.rb'))
CACHED_PATH = File.join(Dir.tmpdir,File.basename(CACHED_FILE))
