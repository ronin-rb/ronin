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

require 'open_namespace'

module Ronin
  #
  # When included into other namespaces, it allows for auto-loading Classes
  # or Modules via {#const_missing}.
  #
  # @since 1.1.0
  #
  module AutoLoad
    def self.included(base)
      base.send :include, OpenNamespace
      base.send :extend, ClassMethods
    end

    module ClassMethods
      protected

      #
      # Transparently auto-loads Classes and Modules from their respective
      # files using [OpenNamespace](http://rubydoc.info/gems/open_namespace).
      #
      # @param [String, Symbol] name
      #   The name of the Class or Module to auto-load.
      #
      # @return [Class, Module]
      #   The loaded Class or Module.
      #
      # @raise [NameError]
      #   The Class or Module could not be found.
      #
      # @since 1.1.0
      #
      # @api public
      #
      def const_missing(name)
        const = super(name)

        if Object.const_defined?('DataMapper')
          # if the loaded Class is a DataMapper Resource, re-finalize
          if const < DataMapper::Resource
            DataMapper.finalize
          end
        end

        return const
      end
    end
  end
end
