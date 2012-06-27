#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model'
require 'ronin/model/has_unique_name'

require 'dm-is-predefined'

module Ronin
  #
  # Represents a {URL} scheme.
  #
  class URLScheme

    include Model
    include Model::HasUniqueName
    
    is :predefined

    # primary key of the URL Scheme
    property :id, Serial

    # The URLs that use the scheme
    has 0..n, :urls, :model     => 'URL',
                     :child_key => [:scheme_id]

    # Predefines the HTTP URL Scheme
    predefine :http, :name => 'http'

    # Predefines the HTTPS URL Scheme
    predefine :https, :name => 'https'

    # Predefines the FTP URL Scheme
    predefine :ftp, :name => 'ftp'

  end
end
