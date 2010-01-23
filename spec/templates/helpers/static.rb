require 'ronin/config'

module Helpers
  STATIC_TEMPLATE_DIR = File.expand_path(File.join(File.dirname(__FILE__),'static'))

  Ronin::Config.static_dir STATIC_TEMPLATE_DIR
end
