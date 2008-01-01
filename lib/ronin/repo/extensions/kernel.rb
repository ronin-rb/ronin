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

module Kernel

  protected

  def ronin_pending_contexts
    @@ronin_pending_contexts ||= []
  end

  def ronin_context_pending?
    !(ronin_pending_contexts.empty?)
  end

  def ronin_contexts
    @@ronin_context_block ||= {}
  end

  def ronin_pending_objects
    @@ronin_pending_objects ||= []
  end

  def ronin_object_pending?
    !(ronin_pending_objects.empty?)
  end

  def ronin_objects
    @@ronin_object_block ||= {}
  end

end
