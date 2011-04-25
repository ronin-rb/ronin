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
    module HasVersion
      #
      # Class methods that are added when {HasVersion} is included into a
      # model.
      #
      module ClassMethods
        #
        # Finds all models with a specific version.
        #
        # @param [String] version
        #   The specific version to search for.
        #
        # @return [Array]
        #   The models with the specific version.
        #
        # @api public
        #
        def revision(version)
          all(:version => version.to_s)
        end

        #
        # Finds latest version of the model.
        #
        # @api public
        #
        def latest
          first(:order => [:version.desc])
        end
      end
    end
  end
end
