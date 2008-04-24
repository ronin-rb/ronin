#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/objects'
require 'ronin/extensions/meta'

require 'data_mapper'

module Ronin
  module Cacheable
    def self.included(base)
      Objects.cache

      base.module_eval do
        include DataMapper::Persistence

        def self.lazy_migrate!(&block)
          unless self.table.exists?
            self.auto_migrate!
          end

          return block.call if block
          return true
        end

        def self.create(attributes)
          lazy_migrate! { super(attributes) }
        end

        def self.first(*args)
          lazy_migrate! { super(*args) }
        end

        def self.all(options={})
          lazy_migrate! { super(options) }
        end

        def self.find_or_new(options={})
          unless self.table.exists?
            return self.new(options)
          else
            return (self.first(options) || self.new(options))
          end
        end

        def self.save
          lazy_migrate! { super() }
        end
      end
    end
  end
end
