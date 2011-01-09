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
        # @since 1.0.0
        #
        def licensed_under(name)
          all(:license => {:name => name.to_s})
        end
      end
    end
  end
end
