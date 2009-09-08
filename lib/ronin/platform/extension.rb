#
# Ronin - A Ruby platform for exploit development and security research.
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
#

require 'ronin/platform/exceptions/extension_not_found'
require 'ronin/platform/extension_cache'
require 'ronin/platform/platform'
require 'ronin/extensions/kernel'
require 'ronin/static/finders'
require 'ronin/ui/output/helpers'

require 'contextify'

module Ronin
  module Platform
    class Extension

      include Contextify
      include Static::Finders
      include UI::Output::Helpers

      #
      # Creates a new Ronin::Platform::Extension object using the given
      # _block_.
      #
      #   ronin_extension do
      #     ...
      #   end
      #
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
      # Creates a new Extension object.
      #
      # @param [String] name The name to give the newly created Extension
      #                      object.
      #
      # @yield [] The block that will be instance-evaled inside the newly
      #           created Extension object.
      #
      # @example
      #   Extension.new('exploits')
      #
      # @example
      #   Extension.new('awesome') do |ext|
      #     # ...
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
      # Loads all extensions with the matching _name_, into a new extension.
      #
      # @param [String] name The name of the extensions to load.
      #
      # @yield [ext] If a block is given, it will be passed the newly
      #              created extension.
      # @yieldparam [Extension] ext The newly created extension.
      #
      # @return [Extension] The newly created extension.
      #
      # @example
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
      # Loads all extensions with the matching _name_ into a new extension,
      # and then runs the extension.
      #
      # @param [String] name The name of the extensions to load and run.
      #
      # @yield [(ext)] The block that will be called, after the extension
      #                has been setup, and before it has been torendown.
      # @yieldparam [Extension] ext The newly created extension.
      #
      # @return [Extension] The newly created extension.
      #
      # @example
      #   Extension.run('exploits') do |ext|
      #     puts ext.search(:product => 'Apache')
      #   end
      #
      # @see Extension#run.
      #
      def Extension.run(name,&block)
        Extension.load(name) { |ext| ext.run(&block) }
      end

      #
      # Includes all extensions with the matching _name_ into the extension.
      #
      # @param [String] name The name of the extensions to include.
      #
      # @yield [ext] If a block is given, it will be passed the extension,
      #              after the other extensions have been included into it.
      # @yieldparam [Extension] The extension.
      # @return [Extension] The extension.
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
      #
      # @param [String] path The path of the extension directory to include
      #                      from.
      #
      # @yield [ext] If a block is given, it will be passed the extension.
      # @yieldparam [Extension] ext The extension.
      #
      # @return [Extension] The extension.
      # @raise [ExtensionNotFound] The specified _path_ was not a valid
      #                            directory.
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

          if context_block
            catch_all { instance_eval(&context_block) }
          end
        end

        block.call(self) if block
        return self
      end

      #
      # @return [Array] The list of public methods exposed by the extension.
      #
      def exposed_methods
        methods(false).map { |name| name.to_sym }
      end

      #
      # Searches for a public method with the specified _name_.
      #
      # @param [Symbol, String] name The method name to search for.
      #
      # @return [Boolean] Specifies whether there is a public method
      #                   with the specified _name_.
      #
      # @example
      #   ext.has_method?(:console)
      #   # => true
      #
      def has_method?(name)
        exposed_methods.include?(name.to_sym)
      end

      #
      # Calls the setup blocks of the extension.
      #
      # @yield [ext] If a block is given, it will be passed the extension,
      #              once it has been setup.
      # @yieldparam [Extension] ext The extension.
      # @return [Extension] The extension.
      #
      # @example
      #   ext.setup!
      #   # => #<Ronin::Platform::Extension: ...>
      #
      # @example
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
      # @return [Boolean] Specifies whether the extension has been setup.
      #
      def setup?
        @setup == true
      end

      #
      # Run the teardown blocks of the extension.
      #
      # @yield [ext] If a block is given, it will be passed the extension,
      #              before it has been toredown.
      # @yieldparam [Extension] ext The extension.
      # @return [Extension] The extension.
      #
      # @example
      #   ext.teardown!
      #   # => #<Ronin::Platform::Extension: ...>
      #
      # @example
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
      # @return [Boolean] Specifies whether the extension has been toredown.
      #
      def toredown?
        @toredown == true
      end

      #
      # Sets up the extension, passes the extension to the specified
      # _block_ and then tears down the extension.
      #
      # @yield [(ext)] If a block is given, it will be called after the
      #                extension has been setup. When the block has
      #                finished, the extension will be toredown.
      # @yieldparam [Extension] ext The extension.
      # @return [Extension] The extension.
      #
      # @example
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
      # @return [String] The name of the extension.
      #
      def to_s
        @name.to_s
      end

      protected

      #
      # Defines reader methods for the listed instance variables.
      #
      # @param [Array<Symbol, String>] names The names of instance
      #                                      variables to add reader
      #                                      methods for.
      #
      # @example
      #   attr_reader :var1, :var2
      #
      #   self.var1
      #   # => nil
      #
      def attr_reader(*names)
        names.each do |name|
          name = name.to_sym
          ivar_name = "@#{name}"

          instance_eval %{
            def #{name}
              instance_variable_get(#{ivar_name.dump})
            end
          }
        end
      end

      #
      # Defines writer methods for the listed instance variables.
      #
      # @param [Array<Symbol, String>] names The names of the instance
      #                                      variables to define writer
      #                                      methods for.
      #
      # @example
      #   attr_writer :var1, :var2
      #   
      #   self.var1 = :foo
      #   self.var2 = :bar
      #
      def attr_writer(*names)
        names.each do |name|
          name = name.to_sym
          ivar_name = "@#{name}"

          instance_eval %{
            def #{name}=(value)
              instance_variable_set(#{ivar_name.dump},value)
            end
          }
        end
      end

      #
      # Defines reader and writer methods for the listed instance variables.
      #
      # @param [Array<Symbol, String>] names The names of the instance
      #                                      variables to define reader
      #                                      and writer methods for.
      #
      # @example
      #   attr_accessor :var1, :var2
      #
      #   self.var1 = :foo
      #   self.var1
      #   # => :foo
      #
      # @see attr_reader
      # @see attr_writer
      #
      def attr_accessor(*names)
        attr_reader(*names)
        attr_writer(*names)
      end

      #
      # Adds the specified _block_ to the list of blocks to run in order
      # to properly setup the extension.
      #
      # @example
      #   setup do
      #     @var = 'hello'
      #   end
      #
      def setup(&block)
        @setup_blocks << block if block
        return self
      end

      #
      # Adds the specified _block_ to the list of blocks to run in order
      # to properly tear-down the extension.
      #
      # @example
      #   teardown do
      #     @file.close
      #   end
      #
      def teardown(&block)
        @teardown_blocks << block if block
        return self
      end

    end
  end
end
