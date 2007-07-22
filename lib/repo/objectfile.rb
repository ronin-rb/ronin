require 'og'

module Ronin
  module Repo
    class ObjectFile

      attr_reader :path, String

      attr_reader :mtime, Time

      def initialize(path,mtime)
	@path = path
	@mtime = mtime
      end

      def ObjectFile.timestamp(path)
	obj_file = ObjectFile.new(path,File.mtime(path))
	obj_file.save

	ronin_load_objects(path).each do |obj|
	  obj.cache(obj_file)
	end

	return obj_file
      end

      def is_fresh?
	File.mtime(@path)==@mtime
      end

      def is_stale?
	File.mtime(@path)!=@mtime
      end

      def timestamp
	@mtime = File.mtime(@path)
	update
      end

    end
  end
end
