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

require 'ronin/version'

require 'rubygems'

module Ronin
  #
  # The Ronin rubygem and all other Ronin libraries.
  #
  # @return [Array<Gem::Specification>]
  #   The rubygems of Ronin and Ronin libraries.
  #
  def Ronin.gems
    unless class_variable_defined?('@@ronin_gems')
      version = Gem::Version.new(VERSION)
      ronin = Gem.source_index.find_name('ronin',version).first

      @@ronin_gems = []

      if ronin
        # add ronin to the gems list
        @@ronin_gems << ronin

        # add gems depending on ronin
        @@ronin_gems += ronin.dependent_gems.map { |deps| deps.first }
      end
    end

    return @@ronin_gems
  end

  #
  # Find files from within the rubygems of Ronin.
  #
  # @param [String] pattern
  #   A glob pattern to match paths in Ronin rubygems.
  #
  # @return [Array]
  #   The matching paths from within Ronin rubygems.
  #
  def Ronin.find_files(pattern)
    if Ronin.gems.empty?
      pattern = File.join(File.dirname(__FILE__),'..','..',pattern)

      return Dir[File.expand_path(pattern)]
    else
      pattern = File.join('..',pattern)

      return Ronin.gems.inject([]) do |paths,dep|
        paths + Gem.searcher.matching_files(dep,pattern)
      end
    end
  end
end
