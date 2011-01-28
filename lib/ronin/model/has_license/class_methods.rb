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

module Ronin
  module Model
    module HasLicense
      #
      # Class methods that are added when {HasLicense} is included into a
      # model.
      #
      module ClassMethods
        #
        # Finds all models associated with a given license.
        #
        # @param [License, Symbol, String] license
        #   The license which models are associated with.
        #
        # @return [Array<Model>]
        #   The models associated with a given license.
        #
        # @example Query using a predefined {License} resource.
        #   LicensedModel.licensed_under(License.mit)
        #   # => [#<Ronin::LicensedModel: ...>, ...]
        #
        # @example Query using the name of a predefined {License}.
        #   LicensedModel.licensed_under(:cc_by_nc)
        #   # => [#<Ronin::LicensedModel: ...>, ...]
        #
        # @example Query using the name of a {License}.
        #   LicensedModel.licensed_under('GPL-2')
        #   # => [#<Ronin::LicensedModel: ...>, ...]
        #
        # @since 1.0.0
        #
        def licensed_under(license)
          license = case license
                    when License
                      license
                    when Symbol
                      License.predefined_resource(license)
                    else
                      {:name => license.to_s}
                    end

          all(:license => license)
        end
      end
    end
  end
end
