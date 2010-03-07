require 'tempfile'
require 'erb'

module Helpers
  OVERLAY_CACHE = File.expand_path(File.join(File.dirname(__FILE__),'overlays'))

  OVERLAYS = Dir[File.join(OVERLAY_CACHE,'*')].map do |path|
    File.basename(path)
  end

  def create_overlay(name)
    Platform::Overlay.new(File.join(OVERLAY_CACHE,name))
  end

  def overlay_cache
    cache = Platform::OverlayCache.new

    OVERLAYS.each do |name|
      cache.add(create_overlay(name))
    end

    return cache
  end
end
