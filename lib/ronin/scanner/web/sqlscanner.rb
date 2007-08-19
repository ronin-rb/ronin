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

require 'ronin/scanner/web/crawler'
require 'ronin/audit/web/sql/injectiontest'

module Ronin
  module Scanner
    module Web
      class SQLInjectedLink

        # Vulnerable URL
        attr_reader :url

        # Vulnerable parameters of the URL
        attr_reader :params

        def initialize(url,params)
          @url = url
          @params = params
        end

        def to_s
          @url
        end

      end

      class SQLScanner < Crawler

        # Platform to inject upon
        attr_reader :platform

        def initialize(targets,platform=nil)
          super(*targets) do |crawler|
            crawler.capture { |url| url.path.include?('?') }
          end

          @platform = platform
        end

        def scan(*targets,&block)
          vulnerable = []

          crawl(*targets) do |url|
            params = SQLInjection.audit(url,@platform)
            unless params.empty
              injected = SQLInjectedLink.new(url,params)

              vulnerable << injected
              block.call(injected) if block
            end
          end

          return vulnerable
        end

      end
    end
  end
end
