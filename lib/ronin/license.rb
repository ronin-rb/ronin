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

require 'og'

module Ronin
  class License

    # License name
    attr_accessor :name, String, :unqiue => true

    # Description of license
    attr_accessor :description, String

    # URL of the License document
    attr_accessor :url, String

    #
    # Creates a new License object with the specified _name_ and the given
    # _description_ and _url_. If _block_ is given, it will be passed
    # the newly created License object.
    #
    def initialize(name,description=nil,url=nil,&block)
      @name = name
      @description = description
      @url = url

      block.call(self) if block
    end

    #
    # Returns +true+ if the license has the same name, description,
    # and url as the _other_ license, returns +false+ otherwise.
    #
    def ==(other)
      return false unless @name==other.name
      return false unless @description==other.description
      return false unless @url==other.url
      return true
    end

    #
    # Returns the name of the license as a String.
    #
    def to_s
      @name.to_s
    end

    #
    # Provides the builtin License objects.
    #
    def License.builtin
      @@builtin ||= {}
    end

    #
    # Defines a new builtin License object of the specified _name_ and the
    # given _opts_. If block is given, it will be passed the newly created
    # License object.
    #
    # _options_ may contain the following keys:
    # <tt>:description</tt>:: The description of the license.
    # <tt>:url</tt>:: The URL to the license.
    #
    def License.define(name,options={},&block)
      name = name.to_s

      return License.builtin[name] = License.new(name,options[:description],options[:url],&block)
    end

    # GNU Public Licenses
    define 'GPL-2', :description => 'GNU Public License v2.0', :url => 'http://www.gnu.org/licenses/gpl-2.0.txt'
    define 'GPL-3', :description => 'GNU Public License v3.0', :url => 'http://www.gnu.org/licenses/gpl-3.0.txt'
    define 'LGPL-3', :description => 'GNU Lesser General Public License v3.0', :url => 'http://www.gnu.org/licenses/lgpl-3.0.txt'

    # Creative Commons Licenses
    define 'CC by', :description => 'Creative Commons Attribution v3.0 License', :url => 'http://creativecommons.org/licenses/by/3.0/'
    define 'CC by-sa', :description => 'Creative Commons Attribution-Share Alike v3.0 License', :url => 'http://creativecommons.org/licenses/by-sa/3.0/'
    define 'CC by-nd', :description => 'Creative Commons Attribution-No Derivative Works v3.0 License', :url => 'http://creativecommons.org/licenses/by-nd/3.0/'
    define 'CC by-nc', :description => 'Creative Commons Attribution-Noncommercial v3.0 License', :url => 'http://creativecommons.org/licenses/by-nc/3.0/'
    define 'CC by-nc-sa', :description => 'Creative Commons Attribution-Noncommercial-Share Alike v3.0 License', :url => 'http://creativecommons.org/licenses/by-nc-sa/3.0/'
    define 'CC by-nc-nd', :description => 'Creative Commons Attribution-Noncommercial-No Derivative Works v3.0 License', :url => 'http://creativecommons.org/licenses/by-nc-nd/3.0/'

  end
end
