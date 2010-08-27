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

module Ronin
  module Model
    module HasAuthors
      module ClassMethods
        #
        # Finds all resources associated with a given author.
        #
        # @param [String] name
        #   The name of the author.
        #
        # @return [Array<Model>]
        #   The resources written by the author.
        #
        def written_by(name)
          all(self.authors.name.like => "%#{name}%")
        end

        #
        # Finds all resources associated with a given organization.
        #
        # @param [String] name
        #   The name of the organization.
        #
        # @return [Array<Model>]
        #   The resources associated with the organization.
        #
        def written_for(name)
          all(self.authors.organization.like => "%#{name}%")
        end
      end
    end
  end
end
