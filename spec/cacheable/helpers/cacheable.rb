require 'tmpdir'
require 'fileutils'

CACHEABLE_FILE = File.expand_path(File.join(File.dirname(__FILE__),'contexts','ronin_cacheable_model.rb'))
CACHEABLE_PATH = File.join(Dir.tmpdir,File.basename(CACHEABLE_FILE))
