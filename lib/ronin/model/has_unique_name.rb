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

require 'ronin/model/has_name/class_methods'

module Ronin
  module Model
    #
    # Adds a unique `name` property to a model.
    #
    module HasUniqueName
      def self.included(base)
        base.send :include, Model
        base.send :extend, HasName::ClassMethods

        base.module_eval do
          # The name of the model
          property :name, String, :required => true, :unique => true
        end
      end

      #
      # Converts the named resource into a String.
      #
      # @return [String]
      #   The name of the resource.
      #
      # @since 1.0.0
      #
      def to_s
        self.name.to_s
      end

      #
      # Inspects the resource with the unique name.
      #
      # @return [String]
      #   The inspected resource.
      #
      # @since 1.0.0
      #
      def inspect
        "#<#{self.class}:#{self.name}>"
      end
    end
  end
end
