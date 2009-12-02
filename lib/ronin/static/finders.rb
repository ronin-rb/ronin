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

require 'ronin/static/static'

module Ronin
  module Static
    module Finders
      #
      # Passes all possible static paths for the specified path,
      # within the static directories, to the given block.
      #
      # @param [String] path
      #   The path to search for within all static directories.
      #
      # @yield [potential_path]
      #   The given block will be passed every possible combination of the
      #   given path and the static directories.
      #
      # @yieldparam [String] potential_path
      #   A potentially valid path.
      #
      def static_paths(path,&block)
        Static.static_dirs.each do |dir|
          block.call(File.join(dir,path))
        end
      end

      #
      # Searches for the given path within any static directory.
      #
      # @param [String] path
      #   The path to search for.
      #
      # @return [String, nil]
      #   Returns the first valid match for the given path within a static
      #   directory. Returns +nil+ if the given path could not be found
      #   in any static directory.
      #
      def static_find(path)
        static_paths(path) do |full_path|
          return full_path if File.exists?(full_path)
        end

        return nil
      end

      #
      # Searches for a file at the given path, within any static directory.
      #
      # @param [String] path
      #   The file path to search for.
      #
      # @return [String, nil]
      #   Returns the first valid file at the given path within a static
      #   directory. Returns +nil+ if the given path could not be found
      #   in any static directory.
      #
      def find_static_file(path)
        static_paths(path) do |full_path|
          return full_path if File.file?(full_path)
        end

        return nil
      end

      #
      # Searches for a directory at the given path, within any static
      # directory.
      #
      # @param [String] path
      #   The directory path to search for.
      #
      # @return [String, nil]
      #   Returns the first valid directory at the given path within a
      #   static directory. Returns +nil+ if the given path could not be
      #   found in any static directory.
      #
      def find_static_dir(path)
        static_paths(path) do |full_path|
          return full_path if File.directory?(full_path)
        end

        return nil
      end

      #
      # Searches for the first set of paths that match the given pattern,
      # within any static directory.
      #
      # @param [String] pattern
      #   The path glob pattern to search with.
      #
      # @return [Array<String>]
      #   The Array of paths that match the given pattern within a static
      #   directory.
      #
      def static_glob(pattern)
        static_paths(pattern) do |full_path|
          paths = Dir[full_path]

          return paths unless paths.empty?
        end

        return []
      end

      #
      # Finds all occurrences of a given path, within all static
      # directories.
      #
      # @param [String] path
      #   The path to search for.
      #
      # @return [Array<String>]
      #   The occurrences of the given path within all static directories.
      #
      def static_find_all(path)
        paths = []

        static_paths(path) do |full_path|
          paths << full_path if File.exists?(full_path)
        end

        return paths
      end

      #
      # Finds all occurrences of a given path, within all static
      # directories.
      #
      # @param [String] path
      #   The path to search for.
      #
      # @yield [static_path]
      #   If a block is given, it will be passed every found path.
      #
      # @yieldparam [String] static_path
      #   A path within a static directory.
      #
      # @return [Array<String>]
      #   The occurrences of the given path within all static directories.
      #
      def each_static_path(path,&block)
        static_find_all(path).each(&block)
      end

      #
      # Finds all occurrences of a given file path, within all static
      # directories.
      #
      # @param [String] path
      #   The file path to search for.
      #
      # @return [Array<String>]
      #   The occurrences of the given file path within all static
      #   directories.
      #
      def find_static_files(path)
        paths = []

        static_paths(path) do |full_path|
          paths << full_path if File.file?(full_path)
        end

        return paths
      end

      #
      # Finds all occurrences of a given file path, within all static
      # directories.
      #
      # @param [String] path
      #   The file path to search for.
      #
      # @yield [static_file]
      #   If a block is given, it will be passed every found path.
      #
      # @yieldparam [String] static_file
      #   The path of a file within a static directory.
      #
      # @return [Array<String>]
      #   The occurrences of the given file path within all static
      #   directories.
      #
      def each_static_file(path,&block)
        find_static_files(path).each(&block)
      end

      #
      # Finds all occurrences of a given directory path, within all static
      # directories.
      #
      # @param [String] path
      #   The directory path to search for.
      #
      # @return [Array<String>]
      #   The occurrences of the given directory path within all static
      #   directories.
      #
      def find_static_dirs(path)
        paths = []

        static_paths(path) do |full_path|
          paths << full_path if File.directory?(full_path)
        end

        return paths
      end

      #
      # Finds all occurrences of a given directory path, within all static
      # directories.
      #
      # @param [String] path
      #   The directory path to search for.
      #
      # @yield [static_dir]
      #   If a block is given, it will be passed every found path.
      #
      # @yieldparam [String] static_dir
      #   The path of a directory within a static directory.
      #
      # @return [Array<String>]
      #   The occurrences of the given directory path within all static
      #   directories.
      #
      def each_static_dir(path,&block)
        find_static_dirs(path).each(&block)
      end

      #
      # Finds all paths that match a given pattern, within all static
      # directories.
      #
      # @param [String] pattern
      #   The path glob pattern to search with.
      #
      # @return [Array<String>]
      #   The matching paths found within all static directories.
      #
      def static_glob_all(pattern)
        paths = []

        static_paths(pattern) do |full_path|
          paths += Dir[full_path]
        end

        return paths
      end
    end
  end
end
