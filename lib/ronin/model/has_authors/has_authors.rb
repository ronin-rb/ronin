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

require 'ronin/model/has_authors/class_methods'
require 'ronin/model/model'
require 'ronin/author'

module Ronin
  module Model
    #
    # Adds an `authors` relationship between a model and the {Author} model.
    #
    module HasAuthors
      #
      # Adds the `authors` relationship and {ClassMethods} to the model.
      #
      # @param [Class] base
      #   The model.
      #
      # @api semipublic
      #
      def self.included(base)
        base.send :include, Model
        base.send :extend, ClassMethods

        base.module_eval do
          # The authors associated with the model.
          has 0..n, :authors, Ronin::Author, :through => DataMapper::Resource

          Ronin::Author.has 0..n, self.relationship_name,
                                  :through => DataMapper::Resource,
                                  :model => self
        end
      end

      #
      # Adds a new author to the resource.
      #
      # @param [Hash] attributes
      #   Additional attributes to create the new author.
      #
      # @example
      #   author :name => 'Anonymous',
      #          :email => 'anon@example.com',
      #          :organization => 'Anonymous LLC'
      #
      # @api public
      #
      def author(attributes)
        self.authors.new(attributes)
      end
    end
  end
end
