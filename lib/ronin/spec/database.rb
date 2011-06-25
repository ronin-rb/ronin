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

require 'ronin/database'

require 'rspec'
require 'tempfile'

RSpec.configure do |spec|
  spec.before(:suite) do
    database_file = Tempfile.new('ronin_database').path
    database_uri = {:adapter => 'sqlite3', :path => database_file}

    Ronin::Database.repositories[:default] = database_uri

    # setup the database
    Ronin::Database.setup

    # auto-migrate any models defined in the specs
    DataMapper.finalize.auto_migrate!
  end
end
