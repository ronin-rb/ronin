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

require 'ronin/version'

require 'enumerator'

module Ronin
  #
  # The {Installation} module provides methods which help reflect on the
  # installation of Ronin on the system.
  #
  module Installation
    #
    # Finds the installed Ronin libraries via RubyGems.
    #
    # @return [Hash{String => Gem::Specification}]
    #   The names and gem-specs of the installed Ronin libraries.
    #
    # @since 0.4.0
    #
    def Installation.gems
      Installation.load_gemspecs! unless defined?(@@ronin_gems)

      return @@ronin_gems
    end

    #
    # The names of the additional Ronin libraries installed on the system.
    #
    # @return [Array<String>]
    #   The library names.
    #
    # @since 0.4.0
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
    # @since 0.4.0
    #
    def Installation.paths
      Installation.load_gemspecs! unless defined?(@@ronin_gem_paths)

      return @@ronin_gem_paths
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
    # @since 0.4.0
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
    # @since 0.4.0
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
    # @since 0.4.0
    #
    def Installation.load_gemspecs!
      version = Gem::Requirement.new(">=#{Ronin::VERSION}")
      ronin_gem = Gem.source_index.find_name('ronin',version).first

      @@ronin_gems = {}
      @@ronin_gem_paths = {}

      if ronin_gem
        @@ronin_gems['ronin'] = ronin_gem
        @@ronin_gem_paths['ronin'] = ronin_gem.full_gem_path

        ronin_gem.dependent_gems.each do |gems|
          gem = gems.first

          @@ronin_gems[gem.name] = gem
          @@ronin_gem_paths[gem.name] = gem.full_gem_path
        end
      else
        # if we cannot find an installed ronin gem, search the $LOAD_PATH
        # for ronin gemspecs and load those
        $LOAD_PATH.each do |lib_dir|
          root_dir = File.expand_path(File.join(lib_dir,'..'))
          gemspec_path = Dir[File.join(root_dir,'ronin*.gemspec')].first

          if gemspec_path
            gem = Gem::SourceIndex.load_specification(gemspec_path)

            @@ronin_gems[gem.name] = gem
            @@ronin_gem_paths[gem.name] = root_dir
          end
        end
      end

      return true
    end
  end
end
