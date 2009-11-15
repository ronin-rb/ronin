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

require 'ronin/database/database'
require 'ronin/extensions/meta'

module Ronin
  module Model
    module LazySetup
      def self.included(base)
        base.metaclass_eval do
          #
          # Determines if the model has been auto-upgraded recently.
          #
          # @return [Boolean]
          #   Specifies whether the model has been auto-upgraded.
          #
          def auto_upgraded?
            @auto_upgraded == true
          end

          #
          # Destructively migrates the data-store to match the model.
          #
          # @param [Symbol] repository
          #   The repository to be migrated
          #
          def auto_migrate!(repository=self.repository_name)
            Ronin::Database.setup unless Ronin::Database.setup?

            result = super(repository)

            @auto_upgraded = true
            return result
          end

          #
          # Safely migrates the data-store to match the model preserving
          # data already in the data-store.
          #
          # @param [Symbol] repository
          #   The repository to be migrated 
          #
          def auto_upgrade!(repository=self.repository_name)
            Ronin::Database.setup unless Ronin::Database.setup?

            result = super(repository)

            @auto_upgraded = true
            return result
          end

          #
          # Safely migrates the data-store to match the model, but only if
          # the model has not yet been migrated.
          #
          # @param [Symbol] repository
          #   The repository to be migrated 
          #
          def lazy_upgrade!(repository=self.repository_name)
            auto_upgrade!(repository) unless auto_upgraded?
          end

          def new(*arguments,&block)
            self.lazy_upgrade!

            super(*arguments,&block)
          end

          def create(*arguments)
            self.lazy_upgrade!

            super(*arguments)
          end

          def all(*arguments)
            self.lazy_upgrade!

            super(*arguments)
          end

          def first(*arguments)
            self.lazy_upgrade!

            super(*arguments)
          end
        end
      end
    end
  end
end
