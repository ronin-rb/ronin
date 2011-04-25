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

require 'ronin/model/has_license/class_methods'
require 'ronin/model/model'
require 'ronin/license'

module Ronin
  module Model
    #
    # Adds a `license` relationship between a model and the {License} model.
    #
    module HasLicense
      #
      # Adds the `license` relationship and {ClassMethods} to the model.
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
          # The license
          belongs_to :license, Ronin::License, :required => false

          Ronin::License.has 0..n, self.relationship_name, :model => self
        end
      end

      #
      # Sets the license of the model.
      #
      # @param [Symbol, String] name
      #   The name of the license to use.
      #
      # @return [License]
      #   The new license of the model.
      #
      # @example
      #   license! :mit
      #
      # @since 1.0.0
      #
      # @api public
      #
      def license!(name)
        self.license = Ronin::License.predefined_resource(name)
      end
    end
  end
end
