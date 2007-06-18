require 'uri'
require 'open-uri'
require 'hpricot'

module Ronin
  class WebCrawler

    # Targeted URLs
    attr_reader :targets

    # Visited URLs
    attr_reader :visited

    # Delay between page requests
    attr_accessor :delay

    def initialize(*targets,&block)
      @targets = targets.map { |url| URI.parse(url.to_s) }
      @visited = []
      @delay = 0.5

      @scrap_block = nil
      @parse_block = nil
      @follow_block = nil
      @nofollow_block = nil
      @capture_block = nil

      block.call(self) if block
    end

    def scrap(&block)
      @scrap_block = block
    end

    def parser(&block)
      @parse_block = block
    end

    def follow(&block)
      @follow_block = block
    end

    def nofollow(&block)
      @nofollow_block = block
    end

    def capture(&block)
      @capture_block = block
    end

    def is_targeted?(url)
      @targets.each do |target|
	if (url.host==target.host && url.path.index(target.path)==0)
	  return true
	end
      end
      return false
    end

    def was_visited?(url)
      @visited.include?(url)
    end

    def crawl(*targets,&block)
      @visited = []

      pending = @targets | targets.map { |url| URI.parse(url.to_s) }
      captured = []

      while !(pending.empty?)
	parse(pending.shift) do |link|
	  if (is_targeted?(link) && !(was_visited?(link)))
	    if capture?(link,&block)
	      caputred << link unless captured.include?(link)
	    elsif follow?(link)
	      pending << link unless pending.include?(link)
	    end
	  end
	end

	sleep(@delay) unless @delay==0
      end

      return captured
    end

    protected

    def follow?(url)
      if @nofollow_block
	return false if @nofollow_block.call(url)

	@follow_block.call(url) if @follow_block
      end
      return true
    end

    def capture?(url,&block)
      if (@capture_block && @capture_block.call(url))
	block.call(url)
      end
    end

    def parse(url,&block)
      @visited << url unless visited.include?(url)

      doc = Hpricot(open(url))
      @scrap_block.call(doc) if @scrap_block

      if @parse_block
	@parse_block.call(url,doc,&block)
      else
	doc.search("a[@href]").each do |link|
	  link_url = URI.parse(link.attributes['href'])
	  if link_url.relative?
	    link_url = URI.join(url.to_s,link_url.to_s)
	  end

	  block.call(link_url)
	end
      end
    end

  end
end
