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

require 'ronin/script/class_methods'
require 'ronin/script/instance_methods'
require 'ronin/model/model'
require 'ronin/model/has_name'
require 'ronin/model/has_description'
require 'ronin/model/has_version'
require 'ronin/model/has_license'
require 'ronin/model/has_authors'
require 'ronin/model/cacheable'
require 'ronin/ui/output/helpers'

require 'data_paths/finders'
require 'parameters'

module Ronin
  module Script
    include UI::Output::Helpers

    #
    # Adds the following to the Class.
    #
    # * {Script::InstanceMethods}
    # * {Model}
    # * {Model::HasName}
    # * {Model::HasDescription}
    # * {Model::HasVersion}
    # * {Model::HasLicense}
    # * {Model::HasAuthors}
    # * {Model::Cacheable}
    # * [DataPaths::Finders](http://rubydoc.info/gems/data_paths)
    # * [Parameters](http://rubydoc.info/gems/parameters)
    # * {ClassMethods}
    #
    # @api semipublic
    #
    def self.included(base)
      base.send :include, Script::InstanceMethods,
                          Model,
                          Model::HasName,
                          Model::HasDescription,
                          Model::HasVersion,
                          Model::HasLicense,
                          Model::HasAuthors,
                          Model::Cacheable,
                          DataPaths::Finders,
                          Parameters

      base.send :extend, ClassMethods
    end

    # 
    # Loads a script from a file.
    #
    # @param [String] path
    #   The path to the file.
    #
    # @return [Script]
    #   The loaded script.
    #
    # @see Model::Cacheable.load_from
    #
    # @since 1.0.0
    #
    # @api public
    #
    def Script.load_from(path)
      Model::Cacheable.load_from(path)
    end
  end
end
