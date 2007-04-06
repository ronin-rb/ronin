#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

module Ronin
  module Repo
    module FileAccess
      def find_path(path,&block)
	real_path = File.join(@path,path)

	if block
	  return block.call(real_path)
	else
	  unless File.exists?(real_path)
	    return nil
	  end

	  return real_path
	end
      end

      def glob_path(pattern,&block)
	paths = Dir.glob(File.join(@path,pattern))
	
	if block
	  paths.each { |path| block.call(path) }
	else
	  return paths
	end
      end

      def find_file(path,&block)
	if block
	  find_path(path) do |file|
	    block.call(file) if File.file?(file)
	  end
	else
	  files = []

	  find_path(path) do |file|
	    files << file if File.file?(file)
	  end
	  return files
	end
      end

      def find_dir(path,&block)
	if block
	  find_path(path) do |dir|
	    block.call(dir) if File.directory?(dir)
	  end
	else
	  dirs = []

	  find_path(path) do |dir|
	    dirs << dir if File.directory?(dir)
	  end
	  return dirs
	end
      end

      def ronin_load(path)
	find_path(path) do |file|
	  return load(file)
	end
      end

      def ronin_require(path)
	find_path(path) do |file|
	  return require(file)
	end
      end

      def contains?(path,&block)
	find_path(path) do
	  if block
	    return block.call
	  else
	    return true
	  end
	end

	return false
      end

      def contains_file?(path,&block)
	find_file(path) do
	  if block
	    return block.call
	  else
	    return true
	  end
	end

	return false
      end

      def contains_dir?(path,&block)
	find_dir(path) do
	  if block
	    return block.call
	  else
	    return true
	  end
	end

	return false
      end
    end
  end
end
