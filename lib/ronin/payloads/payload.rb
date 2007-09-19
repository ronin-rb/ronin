#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'ronin/parameters'
require 'ronin/author'
require 'ronin/license'

require 'og'

module Ronin
  module Payloads
    class Payload

      include Parameters

      # Name of the specific payload
      attr_accessor :name, String, :index => true

      # Version of the payload
      attr_accessor :version, String

      # Additional comments
      attr_accessor :comments, String

      # Payload data
      attr_accessor :data

      # Author(s) of the payload
      has_many :authors, Author

      # Content license
      has_one :license, License

      schema_inheritance

      def initialize(name=nil,version=nil,&block)
        super()

        @name = name
        @version = version

        instance_eval(&block) if block
      end

      def author(name=ANONYMOUSE,info={:organization=> nil, :pgp_signature => nil, :address => nil, :phone => nil, :email => nil, :site => nil, :biography => nil},&block)
        @authors << Author.new(name,info,&block)
      end

      def builder
      end

      def is_built?
        !(@data.nil? || @data.empty?)
      end

      def build
        @data = ''

        builder
      end

      def cleaner
      end

      def is_clean?
        @data.nil?
      end

      def clean
        cleaner

        @data = nil
      end

      def to_s
        if @version
          return "#{@name}-#{@version}"
        else
          return @name.to_s
        end
      end

    end
  end
end
