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

module Ronin
  module Engine
    module ClassMethods
      #
      # Finds and loads all matching Ronin Engines.
      #
      # @param [Hash] options
      #   Query options.
      #
      # @option options [String] :name
      #   The name to search for.
      #
      # @option options [String] :describing
      #   The description to search for.
      #
      # @option options [String] :version
      #   The version to search for.
      #
      # @option options [String] :license
      #   The license to search for.
      #
      # @return [Array<Engine>]
      #   The Ronin Engine with the matching attributes.
      #
      # @since 1.0.0
      #
      def load_all(options={})
        resources = custom_query(options)
        
        resources.each { |resource| resource.load_original! }
        return resources
      end

      #
      # Finds and loads a specific Ronin Engine.
      #
      # @param [Hash] options
      #   Query options.
      #
      # @option options [String] :name
      #   The name to search for.
      #
      # @option options [String] :describing
      #   The description to search for.
      #
      # @option options [String] :version
      #   The version to search for.
      #
      # @option options [String] :license
      #   The license to search for.
      #
      # @return [Array<Engine>]
      #   The Ronin Engine with the matching attributes.
      #
      # @since 1.0.0
      #
      def load_first(options={})
        if (resource = custom_query(options).first)
          resource.load_original!
        end

        return resource
      end

      protected

      #
      # Creates a custom query for the Ronin Engine.
      #
      # @param [Hash] options
      #   Query options.
      #
      # @option options [String] :name
      #   The name to search for.
      #
      # @option options [String] :describing
      #   The description to search for.
      #
      # @option options [String] :version
      #   The version to search for.
      #
      # @option options [String] :license
      #   The license to search for.
      #
      # @return [DataMapper::Collection]
      #   The custom query for the Ronin Engine.
      #
      # @since 1.0.0
      #
      def custom_query(options)
        query = all

        if options.has_key?(:name)
          query = query.named(options.delete(:name))
        end

        if options.has_key?(:describing)
          query = query.describing(options.delete(:describing))
        end

        if options.has_key?(:version)
          query = query.revision(options.delete(:version))
        end

        if options.has_key?(:license)
          query = query.licensed_under(options.delete(:license))
        end

        return query.all(options)
      end
    end
  end
end
