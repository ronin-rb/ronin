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

require 'ronin/script/instance_methods'
require 'ronin/script/class_methods'
require 'ronin/script/path'
require 'ronin/model/model'
require 'ronin/model/has_name'
require 'ronin/model/has_description'
require 'ronin/model/has_version'
require 'ronin/model/has_license'
require 'ronin/model/has_authors'
require 'ronin/ui/output/helpers'

require 'object_loader'
require 'data_paths/finders'
require 'parameters'

module Ronin
  #
  # @since 1.1.0
  #
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
    # * [ObjectLoader](http://rubydoc.info/gems/object_loader)
    # * [DataPaths::Finders](http://rubydoc.info/gems/data_paths)
    # * [Parameters](http://rubydoc.info/gems/parameters)
    # * {ClassMethods}
    #
    # @api semipublic
    #
    def self.included(base)
      base.send :include, InstanceMethods,
                          Model,
                          Model::HasName,
                          Model::HasDescription,
                          Model::HasVersion,
                          Model::HasLicense,
                          Model::HasAuthors,
                          ObjectLoader,
                          DataPaths::Finders,
                          Parameters

      base.send :extend, ClassMethods

      base.module_eval do
        # The class-name of the cached object
        property :type, DataMapper::Property::Discriminator

        # The cached file of the object
        belongs_to :script_path, Ronin::Script::Path, :required => false
      end

      Path.has 1, base.relationship_name, base, :child_key => [:script_path_id]
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
    # @see Cacheable.load_from
    #
    # @since 1.1.0
    #
    # @api public
    #
    def Script.load_from(path)
      path = File.expand_path(path)
      script = ObjectLoader.load_objects(path).find do |obj|
        obj.class < Script
      end

      unless script
        raise("No cacheable object defined in #{path.dump}")
      end

      script.instance_variable_set('@script_loaded',true)
      script.script_path = Path.new(
        :path => path,
        :timestamp => File.mtime(path),
        :class_name => script.class.to_s
      )

      return script
    end
  end
end
