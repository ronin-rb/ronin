require 'tempfile'
require 'erb'

module Helpers
  OVERLAY_CACHE = File.expand_path(File.join(File.dirname(__FILE__),'overlays'))

  def overlay_cache_path(&block)
    file = Tempfile.new('overlays.yaml')
    path = file.path

    template_path = File.join(File.dirname(__FILE__),'overlays.yaml.erb')
    template = ERB.new(File.read(template_path))

    file.write(template.result(binding))
    file.close

    block.call(path) if block
    return path
  end
end
