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

require 'ronin/ui/cli/model_command'

module Ronin
  module UI
    module CLI
      #
      # A base-command class for listing Database Resources.
      #
      class ResourcesCommand < ModelCommand

        class_option :csv, :type => :boolean
        class_option :xml, :type => :boolean
        class_option :yaml, :type => :boolean
        class_option :json, :type => :boolean

        #
        # Default method performs the query and prints the found resources.
        #
        # @since 1.1.0
        #
        # @api semipublic
        #
        def execute
          print_resources(query)
        end

        protected

        #
        # Default method which will print every queried resource.
        #
        # @param [DataMapper::Resource] resource
        #   A queried resource from the Database.
        #
        # @since 1.1.0
        #
        # @api semipublic
        #
        def print_resource(resource)
          puts resource
        end

        #
        # Prints multiple resources.
        #
        # @param [DataMapper::Collection] resources
        #   The query to print.
        #
        # @since 1.1.0
        #
        # @api semipublic
        #
        def print_resources(resources)
          if options.csv?
            print resources.to_csv
          elsif options.xml?
            print resources.to_xml
          elsif options.yaml?
            print resources.to_yaml
          elsif options.json?
            print resources.to_json
          else
            resources.each { |resource| print_resource(resource) }
          end
        end

      end
    end
  end
end
