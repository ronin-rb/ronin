#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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
#++
#

require 'dm-core'
require 'dm-types'
require 'dm-serializer'
require 'dm-validations'

module Ronin
  module Model
    include DataMapper::Types

    # Name of Ronin's DataMapper repository
    REPOSITORY_NAME = :ronin

    def self.included(base)
      unless base.ancestors.include?(DataMapper::Resource)
        base.module_eval do
          include DataMapper::Resource
          include DataMapper::Migrations

          #
          # Returns the default repository name for the model.
          #
          def self.default_repository_name
            Model::REPOSITORY_NAME
          end

          # The class type property
          property :type, Discriminator

          #
          # Finds the first resource by conditions, or initializes a new
          # resource with the attributes if none found.
          #
          def self.first_or_new(query,attributes={})
            first(query) || new(query.merge(attributes))
          end
        end
      end
    end
  end
end
