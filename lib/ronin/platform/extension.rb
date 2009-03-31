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
require 'ronin/static/finders'

require 'contextify'

module Ronin
  module Platform
    class Extension

      include Contextify
      include Static::Finders

      contextify :ronin_extension

      # Extension file name
      EXTENSION_FILE = 'extension.rb'

      # Extension lib/ directory
      LIB_DIR = 'lib'

      # Extension static/ directory
      STATIC_DIR = 'static'

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
        ext = Extension.new(name)
        ext.include(name)

        block.call(ext) if block
        return ext
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
        Platform.overlays.extension_paths(name).each do |path|
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
      # Returns the list of methods exposed by the extension.
      #
      def exposed_methods
        methods(false).map { |name| name.to_sym }
      end

      #
      # Returns +true+ if the extension context has a public instance method
      # of the matching _name_, returns +false+ otherwise.
      #
      #   ext.has_method?(:console)
      #   # => true
      #
      def has_method?(name)
        exposed_methods.include?(name.to_sym)
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

        if block
          if block.arity == 1
            block.call(self)
          else
            block.call()
          end
        end

        teardown!
        return self
      end

      def static_paths(path,&block)
        @paths.each do |dir|
          static_dir = File.join(dir,STATIC_DIR)
          next unless File.directory?(static_dir)

          block.call(File.join(static_dir,path))
        end

        super(path,&block)
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
