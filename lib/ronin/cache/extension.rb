#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/cache/context'
require 'ronin/cache/repository'

module Ronin
  module Cache
    class Extension

      # Extension file name
      EXTENSION_FILE = 'extension.rb'

      # Extension lib directory
      LIB_DIR = 'lib'

      # Name of extension
      attr_reader :name

      # Paths of similar extensions
      attr_reader :paths

      # Dependency extensions
      attr_reader :dependencies

      contextify :extension

      #
      # Creates a new Extension with the specified _name_. If a
      # _block_ is given, it will be passed the newly created
      # Extension.
      #
      #   Extension.new('exploits')
      #
      #   Extension.new('awesome') do |ext|
      #     ...
      #   end
      #
      def initialize(name,&block)
        @name = name.to_s
        @paths = []
        @dependencies = {}

        @setup_blocks = []
        @action_blocks = {}
        @teardown_blocks = []

        block.call(self) if block
      end

      #
      # Loads an extension at the specified _path_ into a newly created
      # Extension object. If a _block_ is given, it will be passed the
      # newly created Extension object.
      #
      def Extension.load_extension(path,&block)
        Extension.new(File.basename(name)) do |ext|
          ext.include_path(path,&block)
        end
      end

      #
      # Loads an extension at the specified _path_ into a newly created
      # Extension object and then runs it with the specified _block_.
      #
      #   Extension.run_extension('lab/exploits') do |ext|
      #     puts ext.search('apache')
      #   end
      #
      def Extension.run_extension(path,&block)
        Extension.load_extension(path) do |ext|
          ext.run(&block)
        end
      end

      #
      # Loads all extensions with the specified _name_ into a newly created
      # Extension object. If a _block_ is given, it will be passed the
      # newly created Extension object.
      #
      #   Extension.load_extensions('shellcode') do |ext|
      #     puts ext.search('moon_lander')
      #   end
      #
      def Extension.load_extensions(name,&block)
        Extension.new(name) do |ext|
          ext.include(name,&block)
        end
      end

      #
      # Loads all extensions with the specified _name_ into a newly created
      # Extension object and then runs it with the specified _block_.
      #
      #   Extension.run_extensions('exploits') do |ext|
      #     puts ext.search('apache')
      #   end
      #
      def Extension.run_extensions(name,&block)
        Extension.load_extensions(name) do |ext|
          ext.run(&block)
        end
      end

      #
      # Includes all extensions of the specified _name_ into the extension.
      # If a _block_ is given, it will be passed the newly created
      # extension after the extensions of _name_ have been included.
      #
      def include(name,&block)
        Repository.each_path_for_extension(name) do |path|
          include_path(path)
        end

        block.call(self) if block
        return self
      end

      #
      # Includes the extension at the specified _path_ into the extension.
      # If a _block_ is given, it will be passed the newly created
      # extension.
      #
      def include_path(path,&block)
        path = File.expand_path(path)

        unless File.directory?(path)
          raise(ExtensionNotFound,"extension #{path.dump} is not a valid extension",caller)
        end

        # add lib directory to the $LOAD_PATH
        lib_dir = File.expand_path(File.join(path,LIB_DIR))
        if File.directory?(lib_dir)
          $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
        end

        # add to the search paths
        @paths << path

        extension_file = File.join(path,EXTENSION_FILE)
        if File.file?(extension_file)
          # instance_eval the extension block
          context_block = Extension.load_context_block(extension_file)

          instance_eval(&context_block) if context_block
        end

        block.call(self) if block
        return self
      end

      #
      # Loads all similar extensions with the specified _name_ into a
      # newly created Extension object and adds it to the extensions
      # dependencies.
      #
      #   depend 'shellcode'
      #
      def depend(name)
        name = name.to_s

        unless Repository.has_extension?(name)
          raise(ExtensionNotFound,"extension #{name.dump} is not in the repository cache",caller)
        end

        @dependencies[name] ||= Repository.extension(name)
        return self
      end

      #
      # Returns +true+ if the extension has the dependency of the specified
      # _name_, returns +false+ otherwise.
      #
      def depends_on?(name)
        @dependencies.has_key?(name.to_s)
      end

      #
      # Passes all the extension's dependencies and the extension itself to
      # the specified _block_ using the given _options_.
      #
      # _options_ may include the following keys:
      # <tt>:top_down</tt>:: Indicates that distribute will recurse through
      #                      the extensions and their elements in a
      #                      top-down manner. This is distributes default
      #                      behavior.
      # <tt>:bottom_up</tt>:: Indictates that distribute will recurse
      #                       through the extensions and their dependencies
      #                       in a bottom-up manner. Mutually exclusive with
      #                       the <tt>:top_down</tt> option.
      #
      def distribute(options={},&block)
        distribute_deps = lambda {
          @dependencies.map { |ext|
            ext.distribute(options,&block)
          }.flatten
        }

        if options[:bottom_up]
          return distribute_deps.call + [block.call(self)]
        else
          return [block.call(self)] + distribute_deps.call
        end
      end

      #
      # Returns +true+ if the app context has a public instance method
      # of the matching _name_, returns +false+ otherwise.
      #
      #   ext.has_method?(:console) # => true
      #
      def has_method?(name)
        public_methods.include?(name.to_s)
      end

      #
      # Returns an +Array+ of extensions that have the specified _method_.
      # If a _block_ is given, it will be passed each extension with the
      # specified _method_.
      #
      #   ext.extensions_with_method(:console) # => [...]
      #
      #   ext.extensions_with_method(:console) do |ext|
      #     ext.console(ARGV)
      #   end
      #
      def extensions_with_method(method,&block)
        extensions = distribute { |ext|
          ext if ext.has_method?(method)
        }.compact

        extensions.each(&block) if block
        return extensions
      end

      #
      # Calls the setup blocks of the extension's dependencies and the
      # extension itself. If a _block_ is given, it will be passed the
      # extension after it has been setup.
      #
      #   ext.perform_setup # => Extension
      #
      #   ext.perform_setup do |ext|
      #     puts "Extension #{ext} has been setup..."
      #   end
      #
      def perform_setup(&block)
        distribute(:bottom_up => true) do |ext|
          ext.instance_eval do
            @setup_blocks.each do |setup_block|
              setup_block.call(self) if setup_block
            end
          end
        end

        block.call(self) if block
        return self
      end

      #
      # Run the teardown blocks of the extension and it's dependencies.
      # If a _block_ is given, it will be passed the extension before it 
      # has been tore down.
      #
      #   ext.perform_teardown # => Extension
      #
      #   ext.perform_teardown do |ext|
      #     puts "Extension #{ext} is being tore down..."
      #   end
      #
      def perform_teardown(&block)
        block.call(self) if block

        distribute(:top_down => true) do |ext|
          ext.instance_eval do
            @teardown_blocks.each do |teardown_block|
              teardown_block.call(self) if teardown_block
            end
          end
        end

        return self
      end

      #
      # Sets up the extension, passes the extension to the specified
      # _block_ and then tears down the extension.
      #
      #   ext.run do |ext|
      #     ext.console(ARGV)
      #   end
      #
      def run(&block)
        perform_setup

        block.call(self) if block

        perform_teardown
        return self
      end

      #
      # Returns an +Array+ of the names of all actions defined in the
      # extension.
      #
      #   ext.actions # => [...]
      #
      def actions
        @action_blocks.keys
      end

      #
      # Returns +true+ if the extension has the action of the specified
      # _name_, returns +false+ otherwise.
      #
      def has_action?(name)
        @action_blocks.has_key?(name.to_sym)
      end

      def perform_action(name,*args)
        name = name.to_s

        unless has_action?(name)
          raise(UnknownAction,"action #{name.dump} is not defined",caller)
        end

        return run do
          @action_blocks[name.to_sym].call(*args)
        end
      end

      #
      # Find the specified _path_ from within all similar extensions.
      # If a _block_ is given, it will be passed the full path if found.
      #
      #   ext.find_path('data/test')
      #
      #   ext.find_path('data/test') do |path|
      #     puts Dir[File.join(path,'*')]
      #   end
      #
      def find_path(path,&block)
        @paths.each do |ext_path|
          full_path = File.expand_path(File.join(ext_path,path))

          if File.exists?(full_path)
            block.call(full_path) if block
            return full_path
          end
        end

        return nil
      end

      #
      # Find the specified file _path_ from within all similar extensions.
      # If a _block_ is given, it will be passed the full file path if
      # found.
      #
      #   ext.find_file('data/test/file.xml')
      #
      #   ext.find_file('data/test/file.xml') do |file|
      #     REXML::Document.new(open(file))
      #     ...
      #   end
      #
      def find_file(path,&block)
        find_path(path) do |full_path|
          if File.file?(full_path)
            block.call(full_path) if block
            return full_path
          end
        end
      end

      #
      # Find the specified directory _path_ from within all similar
      # extensions. If a _block_ is given, it will be passed the full
      # directory path if found.
      #
      #   ext.find_directory('data/test')
      #
      #   ext.find_directory('data/test') do |dir|
      #     puts Dir[File.join(dir,'*')]
      #   end
      #
      def find_dir(path,&block)
        find_path(path) do |full_path|
          if File.directory?(full_path)
            block.call(full_path) if block
            return full_path
          end
        end
      end

      #
      # Find the paths that match the given pattern from within all similar
      # extensions. If a _block_ is given, it will be passed each matching
      # full path.
      #
      #   ext.glob_paths('data/*') # => [...]
      #
      #   ext.glob_paths('data/*') do |path|
      #     puts path
      #   end
      #
      def glob_paths(pattern,&block)
        full_paths = @paths.inject([]) do |paths,ext_path|
          paths + Dir[File.join(ext_path,pattern)]
        end

        full_paths.each(&block) if block
        return full_paths
      end

      #
      # Find the file paths that match the given pattern from within all
      # similar extensions. If a _block_ is given, it will be passed each
      # matching full file path.
      #
      #   ext.glob_files('data/*.xml') # => [...]
      #
      #   ext.glob_files('data/*.xml') do |file|
      #     puts file
      #   end
      #
      def glob_files(pattern,&block)
        full_paths = glob_paths(pattern).select do |path|
          File.file?(path)
        end

        full_paths.each(&block) if block
        return full_paths
      end

      #
      # Find the directory paths that match the given pattern from within
      # all similar extensions. If a _block_ is given, it will be passed
      # each matching full directory path.
      #
      #   ext.glob_dirs('builds/*') # => [...]
      #
      #   ext.glob_dirs('builds/*') do |dir|
      #     puts dir
      #   end
      #
      def glob_dirs(pattern,&block)
        full_paths = glob_paths(pattern).select do |path|
          File.directory?(path)
        end

        full_paths.each(&block) if block
        return full_paths
      end

      #
      # Returns the name of the app context in string form.
      #
      def to_s
        @name.to_s
      end

      protected

      #
      # Adds the specified _block_ to the list of blocks to run in order
      # to properly setup the extension.
      #
      def setup(&block)
        @setup_blocks << block if block
        return self
      end

      def action(name,&block)
        name = name.to_s

        if has_action?(name)
          raise(ActionRedefined,"action #{name.dump} previously defined",caller)
        end

        @action_blocks[name.to_sym] = block
        return self
      end

      #
      # Adds the specified _block_ to the list of blocks to run in order
      # to properly tear-down the extension.
      #
      def teardown(&block)
        @teardown_blocks << block if block
        return self
      end

      #
      # Provides transparent access to the performing of actions
      # and extensions dependencies.
      #
      #   ext.scan('localhost') # => Extension
      #
      #   ext.shellcode # => Extension
      #
      #   ext.shellcode do |dep|
      #     puts "#{ext} has the dependency #{dep}"
      #   end
      #
      def method_missing(sym,*args,&block)
        if (args.length==0)
          name = sym.to_s

          if (has_action?(name) && block.nil?)
            return perform_action(name,*args)
          end

          if depends_on?(name)
            block.call(@dependencies[name]) if block
            return @dependencies[name]
          end
        end

        return super(sym,*args,&block)
      end

    end
  end
end
