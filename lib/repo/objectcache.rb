require 'sqlite3'
require 'yaml'
require 'repo/objecttemplate'

module Ronin
  module Repo
    class ObjectCache

      include SQLite3

      # Path to object cache
      attr_reader :path

      def initialize(path)
	@path = path
	@db = Database.new(path)

	# we like hashes
	@db.results_as_hash = true

	# turn on type translation, because it rocks!
	@db.type_translation = true

	# register our own yaml type
	@db.translator.add_translator("yaml") do |type,value|
	  YAML::load(value)
	end

	begin
	  # initialize the objects table
	  @db.execute_batch <<-SQL
	    create table if not exists objects (path varchar unique, type varchar, mtime timestamp);
	    create table if not exists fields (object_type varchar, name varchar, type varchar);
	  SQL
	rescue SQLException => error
	  puts error
	end
      end

      def timestamps(paths,&block)
	begin
	  @db.execute("select (path, mtime) from objects") do |row|
	    block.call(row['path'],row['mtime']) if paths.include?(row['path'])
	  end
	rescue SQLException => error
	  puts error
	end
      end

      def timestamp(path)
	begin
	  row = @db.get_first_row("select (mtime) from objects where (path = :path)",:path => path)

	  return nil unless row
	  return row['mtime']
	rescue SQLException => error
	  puts error
	end
      end

      def is_cached?(path)
	begin
	  !(@db.get_first_row("select (path) from objects where (path = :path)",:path => path).nil?)
	rescue SQLException => error
	  puts error
	end
      end

      def cached(paths,&block)
	begin
	  @db.execute("select * from objects") do |row|
	    block.call(row['path']) if paths.include?(row['path'])
	  end
	rescue SQLException => error
	  puts error
	end
      end

      def is_stale?(path)
	mtime = timestamp(path)

	return true unless mtime
	return File.mtime(path)!=mtime
      end

      def stale(paths,&block)
	timestamps(paths) do |path,mtime|
	  block.call(path) unless File.mtime(path)==mtime
	end
      end

      def find(type,where=nil,*args,&block)
	objects = []
	where = "where (#{where})" if where

	begin
	  @db.execute("select * from :table #{where}",:table => type,*args) do |row|
	    if block
	      template = ObjectTemplate.new(row)

	      if block.call(template)
		objects << ronin_load_object(type,row.path)
	      end
	    else
	      objects << ronin_load_object(type,row.path)
	    end
	  end
	rescue SQLException => error
	  puts error
	end

	return objects
      end

      def cache(paths)
	paths.each do |path|
	  begin
	    @db.execute("insert into objects values (:path, :mtime)",:path => File.expand_path(path),:mtime => File.mtime?(path))

	    ronin_load_objects(path).each do |object|
	      types = ObjectCache.sanitize_metatype(ObjectCache.metatype[object.context_id]).join(", ")
	      @db.execute("create table if not exists :table (#{types})",:table => object.context_id)

	      values = ObjectCache.sanitize_metadata(object.metadata).join(", ")
	      @db.execute("insert into :table values (:path, #{values})",:table => object.context_id,:path => object.path)
	    end
	  end
	rescue SQLException => error
	  puts error
	end
      end

      def update
	begin
	  # find modified object contexts
	  @db.execute("select * from objects") do |row|
	    unless File.mtime(row.path)==row.timestamp
	      # update objects table with new mtimes
	      ronin_load_objects(row.path).each do |object|
		types = ObjectCache.sanitize_metatype(ObjectCache.metatype[object.context_id])
		values = ObjectCache.sanitize_metadata(object.metadata)

		@db.execute("update :table set (#{values})",:table => object.context_id)
	      end

	      @db.execute("update objects where (path = :path) set (mtime = :mtime)",:path => row.path,:mtime => File.mtime(row.path))
	    end
	  end
	rescue SQLException => error
	  puts error
	end
      end

      def to_s
	@path
      end

      protected

      def ObjectCache.sanitize_metatype(metatype)
	metatype.values.map do |cls|
	  if cls==Fixnum
	    'int'
	  elsif cls==String
	    'varchar'
	  else
	    'yaml'
	  end
	end
      end

      def ObjectCache.sanitize_metadata(metadata)
	metadata.values.map do |data|
	  if data.kind_of?(Fixnum)
	    data
	  elsif data.kind_of?(String)
	    "'"+Database.quote(data)+"'"
	  else
	    "'"+Database.quote(YAML::dump(data))+"'"
	  end
	end
      end

      def metatype(obj_type)
	metatype = {}

	@db.execute("select (name, type) from fields where (obj_type = :obj_type)",:obj_type => obj_type) do |row|
	  metatype[row.name] = row.type
	end
	return metatypes
      end

    end
  end
end
