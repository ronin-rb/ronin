#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'erb'

module Ronin
  module Templates
    module Erb
      #
      # Renders the specified inline ERB _template_ in the scope of the
      # object, returning the resulting +String+.
      #
      #   @user = 'lolcats'
      #
      #   erb %{
      #   USER: <%= @user %>
      #   PASSWORD: <%= @user.reverse %>
      #   }
      #   # => "\nUSER: lolcats\nPASSWORD: staclol\n"
      #
      def erb(template)
        ERB.new(template).result(binding)
      end

      #
      # Renders the ERB template at the specified _path_ in the scope of the
      # object, returning the resulting +String+.
      #
      #   erb_file 'path/to/template.erb'
      #
      def erb_file(path)
        erb(File.read(path))
      end
    end
  end
end
