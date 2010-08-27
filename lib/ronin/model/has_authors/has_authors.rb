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

require 'ronin/model/has_authors/class_methods'
require 'ronin/model/model'
require 'ronin/author'

module Ronin
  module Model
    #
    # Adds an `authors` relation between a model and the `Ronin::Author`
    # model.
    #
    module HasAuthors
      def self.included(base)
        base.send :include, Model
        base.send :extend, ClassMethods

        base.module_eval do
          # The authors associated with the model.
          has 0..n, :authors, :model => 'Ronin::Author'
        end

        Author.belongs_to base.relationship_name,
                          :model => base.name,
                          :required => false
      end

      #
      # Adds a new author to the resource.
      #
      # @param [Hash] attributes
      #   Additional attributes to create the new author.
      #
      # @yield [author]
      #   If a block is given, it will be passed the newly created author
      #   object.
      #
      # @yieldparam [Author] author
      #   The author object associated with the resource.
      #
      # @example
      #   author :name => 'Anonymous',
      #          :email => 'anon@example.com',
      #          :organization => 'Anonymous LLC'
      #
      def author(attributes={},&block)
        self.authors << Author.new(attributes,&block)
      end
    end
  end
end
