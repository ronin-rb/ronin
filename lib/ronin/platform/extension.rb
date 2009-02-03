#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/platform/exceptions/extension_not_found'
require 'ronin/platform/extension_cache'
require 'ronin/platform/platform'

module Ronin
  module Platform
    class Extension

      # Extension file name
      EXTENSION_FILE = 'extension.rb'

      # Name of extension
      attr_reader :name

      # Paths of similar extensions
      attr_reader :paths

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

        @setup = false
        @toredown = true

        @setup_blocks = []
        @teardown_blocks = []

        instance_eval(&block) if block
      end

      #
      # Loads all extensions with the specified _name_ into a newly created
      # Extension object. If a _block_ is given, it will be passed the
      # newly created Extension object.
      #
      #   Extension.load('shellcode') do |ext|
      #     puts ext.search('moon_lander')
      #   end
      #
      def Extension.load(name,&block)
        Extension.new(name) { |ext| ext.include(name,&block) }
      end

      #
      # Loads all extensions with the specified _name_ into a newly created
      # Extension object and then runs it with the specified _block_.
      #
      #   Extension.run('exploits') do |ext|
      #     puts ext.search(:product => 'Apache')
      #   end
      #
      def Extension.run(name,&block)
        Extension.load(name) { |ext| ext.run(&block) }
      end

      #
      # Includes all extensions of the specified _name_ into the extension.
      # If a _block_ is given, it will be passed the newly created
      # extension after the extensions of _name_ have been included.
      #
      def include(name,&block)
        Platform.overlays.extension_paths(name) do |path|
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
      # Returns +true+ if the extension context has a public instance method
      # of the matching _name_, returns +false+ otherwise.
      #
      #   ext.has_method?(:console) # => true
      #
      def has_method?(name)
        public_methods.include?(name.to_s)
      end

      #
      # Calls the setup blocks of the extension. If a _block_ is given, it 
      # will be passed the extension after it has been setup.
      #
      #   ext.setup!
      #   # => #<Ronin::Platform::Extension: ...>
      #
      #   ext.setup! do |ext|
      #     puts "Extension #{ext} has been setup..."
      #   end
      #
      def setup!(&block)
        unless @setup
          @setup_blocks.each do |setup_block|
            setup_block.call(self) if setup_block
          end

          @setup = true
          @toredown = false
        end

        block.call(self) if block
        return self
      end

      #
      # Returns +true+ if the extension has been setup, returns +false+
      # otherwise.
      #
      def setup?
        @setup == true
      end

      #
      # Run the teardown blocks of the extension. If a _block_ is given,
      # it will be passed the extension before it has been tore down.
      #
      #   ext.teardown!
      #   # => #<Ronin::Platform::Extension: ...>
      #
      #   ext.teardown! do |ext|
      #     puts "Extension #{ext} is being tore down..."
      #   end
      #
      def teardown!(&block)
        block.call(self) if block

        unless @toredown
          @teardown_blocks.each do |teardown_block|
            teardown_block.call(self) if teardown_block
          end

          @toredown = true
          @setup = false
        end

        return self
      end

      #
      # Returns +true+ if the extension has been toredown, returns +false+
      # otherwise.
      #
      def toredown?
        @toredown == true
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
        setup!

        block.call(self) if block

        teardown!
        return self
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
      # Returns the name of the extension context in string form.
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

      #
      # Adds the specified _block_ to the list of blocks to run in order
      # to properly tear-down the extension.
      #
      def teardown(&block)
        @teardown_blocks << block if block
        return self
      end

    end
  end
end
