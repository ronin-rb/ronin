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

require 'ronin/model/model'
require 'ronin/license'

module Ronin
  module Model
    #
    # Adds a `license` relation between a model and the {License} model.
    #
    module HasLicense
      def self.included(base)
        base.send :include, Model

        base.module_eval do
          # The license
          belongs_to :license, :required => false,
                               :model => 'Ronin::License'

          #
          # Finds all models associated with a given license.
          #
          # @param [Symbol, String] name
          #   The name of the license which models are associated with.
          #
          # @return [Array<Model>]
          #   The models associated with a given license.
          #
          # @example
          #   LicensedModel.licensed_under(:cc_by_nc)
          #   # => [#<Ronin::LicensedModel: ...>, ...]
          #
          def self.licensed_under(name)
            self.all(:license => Ronin::License.predefined_resource(name))
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
          # @since 0.4.0
          #
          def license!(name)
            self.license = Ronin::License.predefined_resource(name)
          end
        end

        License.has License.n, base.relationship_name, :model => base.name
      end
    end
  end
end
