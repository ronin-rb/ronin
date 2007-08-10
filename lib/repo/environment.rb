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

require 'repo/config'

require 'yaml'

module Ronin
  module Repo
    class Environment

      # Default path of the environment
      ENVIRONMENT_PATH = File.join(Config::PATH,'env.yml')
      
      # Path of the environment
      attr_reader :path

      def initialize(path=ENVIRONMENT_PATH)
	@path = path.to_s

	if File.file?(path)
	  @env = YAML.load(path)
	else
	  @env = Hash.new { |hash,key| ENV[key.to_s] }
	end
      end

      def [](name)
	@env[name.to_s]
      end

      def []=(name,value)
	@env[name.to_s] = value
      end

      def save(path=@path)
	File.open(path,'w') do |file|
	  YAML.dump(@env,file)
	end
      end

      def to_s
	@path
      end

    end
  end
end
