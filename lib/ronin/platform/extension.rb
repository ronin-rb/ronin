#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/platform/extension_cache'
require 'ronin/platform/platform'
require 'ronin/ui/output/helpers'

require 'contextify'
require 'data_paths/finders'

module Ronin
  module Platform
    class Extension

      include Contextify
      include DataPaths::Finders
      include UI::Output::Helpers

      #
      # Creates a new Ronin::Platform::Extension object.
      #
      # @yield []
      #   If a block is given, it will be evaluated within the new
      #   extension.
      #
      # @example
      #   ronin_extension do
      #     # ...
      #   end
      #
      contextify :ronin_extension

      # Name of extension
      attr_reader :name

      # The paths the extension was loaded from
      attr_reader :paths

      #
      # Creates a new Extension object.
      #
      # @param [String] name
      #   The name to give the newly created Extension object.
      #
      # @yield []
      #   The block that will be instance-evaled inside the newly created
      #   Extension object.
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
      # Includes the extension at the specified path.
      #
      # @param [String] path
      #   The path of the extension file to include.
      #
      # @return [Boolean]
      #   Specifies the path was included successfully.
      #
      # @raise [RuntimeError]
      #   The specified path could not be found.
      #
      def include_path(path)
        path = File.expand_path(path)

        unless File.file?(path)
          raise(RuntimeError,"extension #{path.dump} does not exist",caller)
        end

        return false if @paths.include?(path)

        if File.file?(path)
          # instance_eval the extension block
          context_block = Extension.load_context_block(path)

          @paths << path

          instance_eval(&context_block) if context_block
        end

        return true
      end

      #
      # Includes all extensions with the matching name into the extension.
      #
      # @param [String] name
      #   The name of the extensions to include.
      #
      # @return [Boolean]
      #   Specifies the extension was included successfully.
      #
      def include(name)
        success = false

        Platform.overlays.extension_paths(name).each do |path|
          success = include_path(path)
        end

        return success
      end

      #
      # @return [Array]
      #   The list of public methods exposed by the extension.
      #
      def exposed_methods
        ext_methods = methods(false).sort

        ext_methods.map! { |name| name.to_sym }
        return ext_methods
      end

      #
      # Searches for a public method with the specified name.
      #
      # @param [Symbol, String] name
      #   The method name to search for.
      #
      # @return [Boolean]
      #   Specifies whether there is a public method with the specified
      #   name.
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
      # @yield [ext]
      #   If a block is given, it will be passed the extension, once it
      #   has been setup.
      #
      # @yieldparam [Extension] ext
      #   The extension.
      #
      # @return [Extension]
      #   The extension.
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
      # @return [Boolean]
      #   Specifies whether the extension has been setup.
      #
      def setup?
        @setup == true
      end

      #
      # Run the teardown blocks of the extension.
      #
      # @yield [ext]
      #   If a block is given, it will be passed the extension, before it
      #   has been toredown.
      #
      # @yieldparam [Extension] ext
      #   The extension.
      #
      # @return [Extension]
      #   The extension.
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
      # @return [Boolean]
      #   Specifies whether the extension has been toredown.
      #
      def toredown?
        @toredown == true
      end

      #
      # The temporary directory for the extension.
      #
      # @return [String]
      #   The path to the extensions temporary directory within
      #   {Config::TMP_DIR}.
      #
      def tmp_dir
        @tmp_dir ||= Config.tmp_dir(@name)
      end

      #
      # @return [String]
      #   The name of the extension.
      #
      def to_s
        @name.to_s
      end

      protected

      #
      # Defines reader methods for the listed instance variables.
      #
      # @param [Array<Symbol, String>] names
      #   The names of instance variables to add reader methods for.
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
      # @param [Array<Symbol, String>] names
      #   The names of the instance variables to define writer methods for.
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
      # @param [Array<Symbol, String>] names
      #   The names of the instance variables to define reader and writer
      #   methods for.
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
      # Adds the given block to the list of blocks to run in order to
      # properly setup the extension.
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
      # Adds the given block to the list of blocks to run in order to
      # properly tear-down the extension.
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
