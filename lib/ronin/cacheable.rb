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

        property :cached_path, DataMapper::Types::FilePath

        property :cached_timestamp, DataMapper::Types::EpochTime

        def self.load_from(path)
          path = File.expand_path(path)

          obj = self.load_context(path)
          obj.cached_path = path
          obj.cached_timestamp = File.mtime(path)

          obj.prepare_cache
          return obj
        end

        def self.cache(path)
          path = File.expand_path(path)

          # delete any existing objects
          self.all(:cached_path => path).destroy!

          obj = self.load_from(path)
          obj.save!
          return obj
        end
      end
    end

    def load_file!
      if self.cached_path
        block = self.class.load_context_block(self.cached_path)

        instance_eval(&block) if block
      end

      return self
    end

    def sync!
      if (self.cached_path && self.cached_timestamp)
        if File.file?(self.cached_path)
          if File.mtime(self.cached_path) > self.cached_timestamp
            self.class.cache(self.cached_path)
          else
          end
        else
          self.destroy!
        end
      end

      return false
    end

    def prepare_cache
      unless @cache_prepared
        cache
        @cache_prepared = true
      end
    end

    protected

    #
    # Default cache method.
    #
    def cache
    end
  end
end
