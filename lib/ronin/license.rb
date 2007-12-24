#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'og'

module Ronin
  class License

    # License name
    attr_reader :name, String, :unqiue => true

    # Description of license
    attr_reader :description, String

    # URL of the License document
    attr_reader :url, String

    def initialize(name,description=nil,url=nil)
      @name = name
      @description = description
      @url = url
    end

    def to_s
      @name.to_s
    end

    def License.builtin
      @@builtin ||= {}
    end

    def License.define(opts={})
      name = opts[:name].to_s

      return License.builtin[name] = License.new(name,opts[:description],opts[:url])
    end

    protected

    def Object.license(opts={})
      License.define(opts)
    end

    # GNU Public Licenses
    license 'GPL-2', :description => 'GNU Public License v2.0', :url => 'http://www.gnu.org/licenses/gpl-2.0.txt'
    license 'GPL-3', :description => 'GNU Public License v3.0', :url => 'http://www.gnu.org/licenses/gpl-3.0.txt'
    license 'LGPL-3', :description => 'GNU Lesser General Public License v3.0', :url => 'http://www.gnu.org/licenses/lgpl-3.0.txt'

    # Creative Commons Licenses
    license 'CC by', :description => 'Creative Commons Attribution v3.0 License', :url => 'http://creativecommons.org/licenses/by/3.0/'
    license 'CC by-sa', :description => 'Creative Commons Attribution-Share Alike v3.0 License', :url => 'http://creativecommons.org/licenses/by-sa/3.0/'
    license 'CC by-nd', :description => 'Creative Commons Attribution-No Derivative Works v3.0 License', :url => 'http://creativecommons.org/licenses/by-nd/3.0/'
    license 'CC by-nc', :description => 'Creative Commons Attribution-Noncommercial v3.0 License', :url => 'http://creativecommons.org/licenses/by-nc/3.0/'
    license 'CC by-nc-sa', :description => 'Creative Commons Attribution-Noncommercial-Share Alike v3.0 License', :url => 'http://creativecommons.org/licenses/by-nc-sa/3.0/'
    license 'CC by-nc-nd', :description => 'Creative Commons Attribution-Noncommercial-No Derivative Works v3.0 License', :url => 'http://creativecommons.org/licenses/by-nc-nd/3.0/'

  end
end
