# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/cli/command'

module Ronin
  class CLI
    module Commands
      #
      # Prints a random tip on how to use `ronin`.
      #
      # ## Usage
      #
      #     ronin tips [options]
      #
      # ## Options
      #
      #        --list-categories            Prints all category names
      #    -c, --category STR               Print a random tip from the category
      #    -s, --search TEXT                Searches all tip files for the text
      #    -h, --help                       Print help information
      #
      class Tips < Command

        # Path to the `data/tips/` directory.
        TIPS_DIR = File.join(__dir__,'..','..','..','..','data','tips')

        option :list_categories, desc: 'Prints all category names'

        option :category, value: true,
                          short: '-c',
                          desc:  'Print a random tip from the category'

        option :search, value: {
                          type:  String,
                          usage: 'TEXT'
                        },
                        short: '-s',
                        desc:  'Searches all tip files for the text'

        description 'Prints a random tip on how to use ronin'

        man_page 'ronin-tips.1'

        #
        # Runs the tip command.
        #
        def run
          if options[:list_categories]
            puts tip_category_names
          else
            category = options[:category]

            if category && !tip_category_names.include?(category)
              print_error "unknown category name: #{category}."
              print_error "please see `ronin tips --list-categories` for all category names."
              exit(1)
            end

            if options[:search]
              print_matching_tips(options[:search], category: category)
            else
              print_random_tip(category)
            end
          end
        end

        #
        # All of the paths to the tip category directories.
        #
        # @return [Array<String>]
        #
        def tip_category_paths
          Dir[File.join(TIPS_DIR,'*/')]
        end

        #
        # All of the tip category names.
        #
        # @return [Array<String>]
        #
        def tip_category_names
          tip_category_paths.map { |path| File.basename(path) }
        end

        #
        # Gets the paths to all of the tip files.
        #
        # @param [String, nil] category
        #   The optional tips category to select the tip files from.
        #
        # @return [Array<String>]
        #   The paths to all files in `data/tips/`.
        #
        def tip_paths(category=nil)
          glob_pattern = if category then File.join(TIPS_DIR,category,'*.txt')
                         else             File.join(TIPS_DIR,'{*/}*.txt')
                         end

          return Dir[glob_pattern]
        end

        #
        # Gets a path to a random tipe.
        #
        # @param [String, nil] category
        #   The optional tips category to select the random tip from.
        #
        # @return [String]
        #   The path to the random tip.
        #
        def random_tip_path(category=nil)
          tip_paths(category).sample
        end

        #
        # Searches through all tip files for the given text.
        #
        # @param [String] text
        #   The text to search for.
        #
        # @param [String, nil] category
        #   The optional tips category to search within.
        #
        # @return [Array<String>]
        #   The paths to the tip files containing the matching text.
        #
        def search_tip_files(text, category: nil)
          tip_paths(category).select do |path|
            File.read(path).include?(text)
          end
        end

        #
        # Prints a tip at the given path.
        #
        # @param [String] path
        #   The path to the tip file.
        #
        def print_tip(path)
          contents = File.read(path)

          puts contents

          unless contents.end_with?("#{$/}#{$/}")
            puts
            puts
          end
        end

        #
        # Prints a random tip.
        #
        # @param [String, nil] category
        #   The optional tips category to select the random tip from.
        #
        # @api private
        #
        def print_random_tip(category=nil)
          print_tip(random_tip_path(category))
        end

        #
        # Prints all tips that contain the given text.
        #
        def print_matching_tips(text, category: nil)
          search_tip_files(text, category: category).each do |path|
            print_tip(path)
          end
        end

      end
    end
  end
end
