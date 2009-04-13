#
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model'
require 'ronin/os'
require 'ronin/arch'

module Ronin
  class Target

    include Model

    # Primary key
    property :id, Serial

    # Targeted architecture
    belongs_to :arch

    # Targeted OS
    belongs_to :os,
               :child_key => [:os_id],
               :class_name => 'OS'

    # Validates
    validates_present :arch, :os

  end
end
