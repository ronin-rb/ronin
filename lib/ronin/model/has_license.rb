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

require 'ronin/model'
require 'ronin/license'

require 'extlib'

module Ronin
  module Model
    module HasLicense
      def self.included(base)
        base.module_eval do
          include Ronin::Model

          # The license
          belongs_to :license, :required => false

          #
          # Returns all models having the predefined license with the
          # specified _name_.
          #
          # @param [Symbol, String] name
          #   The name of the license which models are associated with.
          #
          # @example
          #   LicensedModel.licensed_under(:cc_by_nc)
          #   # => [#<Ronin::LicensedModel: ...>, ...]
          #
          def self.licensed_under(name)
            self.all(:license_id => Ronin::License[name].id)
          end
        end

        model_name = base.name.split('::').last.snake_case.plural.to_sym
        License.has License.n, model_name, :model => base.name
      end
    end
  end
end
