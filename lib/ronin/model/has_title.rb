#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model'

module Ronin
  module Model
    #
    # Adds a `title` property to a model.
    #
    module HasTitle
      #
      # Adds the `title` property and {ClassMethods} to the model.
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
          # The title of the model
          property :title, String
        end
      end

      #
      # Class methods that are added when {HasTitle} are included into a
      # model.
      #
      module ClassMethods
        #
        # Finds models with titles containing a given fragment of text.
        #
        # @param [String] fragment
        #   The fragment of text to match titles with.
        #
        # @return [Array<Model>]
        #   The found models.
        #
        # @example
        #   Vuln.titled 'bypass'
        #
        # @api public
        #
        def titled(fragment)
          all(:title.like => "%#{fragment}%")
        end
      end
    end
  end
end
