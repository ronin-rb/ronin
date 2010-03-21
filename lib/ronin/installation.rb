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
      unless defined?(@@ronin_gems)
        version = Gem::Requirement.new(">=#{Ronin::VERSION}")
        ronin_gem = Gem.source_index.find_name('ronin',version).first

        @@ronin_gems = {}

        if ronin_gem
          @@ronin_gems['ronin'] = ronin_gem

          ronin_gem.dependent_gems.each do |gems|
            gem = gems.first

            @@ronin_gems[gem.name] = gem
          end
        end
      end

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
    # Enumerates over all files from all installed Ronin libraries.
    #
    # @yield [file, (gem)]
    #   The given block will be passed each file, from each library.
    #
    # @yieldparam [String] file
    #   The path to the file.
    #
    # @yieldparam [Gem::Specification] gem
    #   The RubyGem that the file belongs to.
    #
    # @return [nil]
    # 
    # @since 0.4.0
    #
    def Installation.each_file(&block)
      Installation.gems.each do |name,gem|
        gem.files.each do |file|
          if block.arity == 2
            block.call(file,gem)
          else
            block.call(file)
          end
        end
      end

      return nil
    end

    #
    # Enumerates over all files within a given directory found in any
    # of the installed Ronin libraries.
    #
    # @param [String] directory
    #   The directory path to search within.
    #
    # @yield [file, (gem)]
    #   The given block will be passed each file found within the directory.
    #
    # @yieldparam [String] file
    #   The path to the file found within the directory.
    #
    # @yieldparam [Gem::Specification] gem
    #   The RubyGem that the file belongs to.
    #
    # @return [nil]
    #
    # @since 0.4.0
    #
    def Installation.each_file_in(directory,&block)
      directory = File.join(directory,'')

      Installation.each_file do |file,gem|
        if file[0..directory.length] == directory
          block.call(directory)
        end
      end

      return nil
    end
  end
end
