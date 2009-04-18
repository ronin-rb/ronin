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

require 'ronin/model'

require 'contextify'

module Ronin
  module Cacheable
    def self.included(base)
      base.module_eval do
        include Contextify
        include Ronin::Model

        property :cached_path, FilePath

        property :cached_timestamp, EpochTime

        def self.cache(path)
          path = File.expand_path(path)

          self.all(:cached_path => path).destroy

          obj = self.load_context(path)
          obj.cached_path = path
          return obj.cache!
        end

        def self.clean(path)
        end
      end
    end

    def reload!
      if self.cached_path
        block = self.class.load_context_block(self.cached_path)

        instance_eval(&block) if block
      end

      return self
    end

    def cache!
      if self.cached_path
        self.cached_timestamp = File.mtime(self.cached_timestamp)

        cache
        return save!
      end

      return false
    end

    def sync!
      if (self.cached_path && self.cached_timestamp)
        if File.file?(self.cached_path)
          if File.mtime(self.cached_path) > self.cached_timestamp
            self.destroy!

            reload!
            return cache!
          else
          end
        else
          self.destroy!
        end
      end

      return false
    end

    protected

    #
    # Default cache method.
    #
    def cache
    end
  end
end
