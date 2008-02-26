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

require 'ronin/object_cache'
require 'ronin/extensions/meta'

require 'og'
require 'og/model/taggable'
require 'rexml/document'
  
class Object

  protected

  def Object.object_contextify(name=Ronin::Cache::ObjectContext.namify(self))
    # contextify the class
    contextify(name)

    include Ronin::Cache::ObjectContext

    # make the class taggable
    include Taggable

    # the path of the object context file
    attr_accessor :object_path, String

    before %{
      path = res[res.fields.index('object_path')]
      if path
        load_object(path)

        @oid = res[res.fields.index('oid')]
        return
      end
    }, :on => :og_read

    if Ronin.object_cache_loaded?
      # manage classes after the object cache has been setup
      Ronin.object_cache.manage(self)
    end

    meta_def(:create_object) do |path,*args|
      path = File.expand_path(path)

      new_obj = self.new(*args)
      new_obj.load_object(path)

      return new_obj
    end

    class_def(:load_object) do |path|
      path = File.expand_path(path)

      load_context(path)

      @object_path = path
      return self
    end

    # define Repo-level object loader method
    Ronin.module_eval %{
      def ronin_load_#{name}(path,&block)
        if (File.extname(path)=='.xml' && #{self}.respond_to?(:from_xml))
          return #{self}.from_xml(REXML::Document.new(path))
        else
          return #{self}.create_object(path,&block)
        end
      end
    }

    # add the class to the global list of object contexts
    Ronin::Cache::ObjectContext.object_contexts[name] = self
  end

end
