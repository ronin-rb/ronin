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

require 'ronin/engine/class_methods'
require 'ronin/engine/instance_methods'
require 'ronin/model/model'
require 'ronin/model/has_name'
require 'ronin/model/has_description'
require 'ronin/model/has_version'
require 'ronin/model/has_license'
require 'ronin/model/has_authors'
require 'ronin/model/cacheable'
require 'ronin/ui/output/helpers'

require 'parameters'

module Ronin
  module Engine
    include UI::Output::Helpers

    def self.included(base)
      base.send :include, Engine::InstanceMethods,
                          Model,
                          Model::HasName,
                          Model::HasDescription,
                          Model::HasVersion,
                          Model::HasLicense,
                          Model::HasAuthors,
                          Model::Cacheable,
                          Parameters

      base.send :extend, ClassMethods
    end

    # 
    # Loads a engine from a file.
    #
    # @param [String] path
    #   The path to the file.
    #
    # @return [Engine]
    #   The loaded engine.
    #
    # @see Model::Cacheable.load_from
    #
    # @since 1.0.0
    #
    def Engine.load_from(path)
      Model::Cacheable.load_from(path)
    end
  end
end
