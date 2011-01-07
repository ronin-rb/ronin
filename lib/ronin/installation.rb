#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'enumerator'

module Ronin
  #
  # The {Installation} module provides methods which help reflect on the
  # installation of Ronin on the system.
  #
  module Installation
    @gems = {}
    @paths = {}

    #
    # Finds the installed Ronin libraries via RubyGems.
    #
    # @return [Hash{String => Gem::Specification}]
    #   The names and gem-specs of the installed Ronin libraries.
    #
    # @since 1.0.0
    #
    def Installation.gems
      Installation.load_gemspecs! if @gems.empty?
      return @gems
    end

    #
    # The names of the additional Ronin libraries installed on the system.
    #
    # @return [Array<String>]
    #   The library names.
    #
    # @since 1.0.0
    #
    def Installation.libraries
      Installation.gems.keys
    end

    #
    # The installation paths of installed Ronin libraries.
    #
    # @return [Hash{String => String}]
    #   The paths to the installed Ronin libraries.
    #
    # @since 1.0.0
    #
    def Installation.paths
      Installation.load_gemspecs! if @paths.empty?
      return @paths
    end

    #
    # Enumerates over all files within a given directory found in any
    # of the installed Ronin libraries.
    #
    # @param [String] directory
    #   The directory path to search within.
    #
    # @yield [file]
    #   The given block will be passed each file found within the directory.
    #
    # @yieldparam [String] file
    #   The sub-path to the file found within the directory.
    #
    # @return [Enumerator]
    #   Returns an Enumerator if no block is given.
    #
    # @since 1.0.0
    #
    def Installation.each_file(directory)
      return enum_for(:each_file,directory) unless block_given?

      directory = File.join(directory,'')

      # query the installed gems
      Installation.gems.each_value do |gem|
        gem.files.each do |file|
          if file[0...directory.length] == directory
            yield file[directory.length..-1]
          end
        end
      end

      return nil
    end

    #
    # Requires all files within the given directory.
    #
    # @param [String] directory
    #   A directory that resides within `lib/`.
    #
    # @return [Boolean]
    #   Specifies whether any files were successfully required.
    #
    # @since 1.0.0
    #
    def Installation.require_all(directory)
      lib_dir = File.join('lib',directory)
      result = false

      Installation.each_file(lib_dir) do |name|
        result |= (require File.join(directory,name))
      end

      return result
    end

    protected

    #
    # Loads the gemspecs for any installed Ronin libraries.
    #
    # @return [true]
    #   All Ronin libraries were successfully found.
    #
    # @since 1.0.0
    #
    def Installation.load_gemspecs!
      ronin_gem = Gem.loaded_specs['ronin']

      if ronin_gem
        @gems['ronin'] = ronin_gem
        @paths['ronin'] = ronin_gem.full_gem_path

        ronin_gem.dependent_gems.each do |gems|
          gem = gems.first

          @gems[gem.name] = gem
          @paths[gem.name] = gem.full_gem_path
        end
      else
        # if we cannot find an installed ronin gem, search the $LOAD_PATH
        # for ronin gemspecs and load those
        $LOAD_PATH.each do |lib_dir|
          root_dir = File.expand_path(File.join(lib_dir,'..'))
          gemspec_path = Dir[File.join(root_dir,'ronin*.gemspec')].first

          if gemspec_path
            gem = Gem::SourceIndex.load_specification(gemspec_path)

            @gems[gem.name] = gem
            @paths[gem.name] = root_dir
          end
        end
      end

      return true
    end
  end
end
