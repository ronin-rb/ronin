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

require 'ronin/ui/console/commands'
require 'ronin/address'
require 'ronin/ip_address'
require 'ronin/host_name'
require 'ronin/email_address'
require 'ronin/url'

require 'set'

Bond.complete(:on => /^\![a-zA-Z]\w*/) do |cmd|
  prefix = cmd[1..-1]
  glob   = "#{prefix}*"
  paths  = Set[]

  # search through $PATH for similar program names
  Env.paths.each do |dir|
    Pathname.glob(dir.join(glob)) do |path|
      if (path.file? && path.executable?)
        paths << "!#{path.basename}"
      end
    end
  end

  # add the black-listed keywords last
  Ronin::UI::Console::Commands::BLACKLIST.each do |keyword|
    paths << "!#{keyword}" if keyword.start_with?(prefix)
  end

  paths
end

#
# {URL} completion in the context of URLs.
#
# 
#     http://www.example.com/in[TAB][TAB] => http://www.example.com/index.html
#
Bond.complete(:anywhere => /[a-z]+:\/\/([^:\/\?]+(:\d+)?(\/[^\?;]*(\?[^\?;]*)?)?)?/) do |url|
  match = url.match(/([a-z]+):\/\/([^:\/\?]+)(:\d+)?(\/[^\?;]*)?(\?[^\?;]*)?/)

  query = Ronin::URL.all('scheme.name' => match[1])

  if match[2]
    unless (match[4] || match[3])
      query = query.all('host_name.address.like' => "#{match[2]}%")
    else
      query = query.all('host_name.address' => match[2])
    end
  end

  if match[3]
    query = query.all('port.number' => match[3])
  end

  if match[4]
    unless match[5]
      query = query.all(:path.like => "#{match[4]}%")
    else
      query = query.all(:path => match[4])
    end
  end

  if match[5]
    params = URI::QueryParams.parse(match[5][1..-1]).to_a

    params[0..-2].each do |name,value|
      query = query.all(
        'query_params.name.name' => name,
        'query_params.value' => value
      )
    end

    if (param = params.last)
      if param[1].empty?
        query = query.all('query_params.name.name.like' => "#{param[0]}%")
      else
        query = query.all(
          'query_params.name.name' => param[0],
          'query_params.value.like' => "#{param[1]}%"
        )
      end
    end
  end

  query
end

#
# {IPAddress} completion:
#
#     192.168.[TAB][TAB] => 192.168.0.1
#
Bond.complete(:anywhere => /(\d{1,3}\.){1,3}\d{,2}/) do |addr|
  Ronin::Address.all(:address.like => "#{addr}%")
end

#
# {HostName} completion:
#
#     www.[TAB][TAB] => www.example.com
#
Bond.complete(:anywhere => /[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]*/) do |host|
  Ronin::HostName.all(:address.like => "#{host}%")
end

#
# {EmailAddress} completeion:
#
#     alice@[TAB][TAB] => alice@example.com
#
Bond.complete(:anywhere => /[a-zA-Z0-9\._-]+@[a-zA-Z0-9\._-]*/) do |email|
  user, host = email.split('@',2)

  Ronin::EmailAddress.all(
    'user_name.name' => user,
    'host_name.address.like' => "#{host}%"
  )
end

#
# Path completion.
#
#     /etc/pa[TAB][TAB] => /etc/passwd
#
Bond.complete(:anywhere => /\/([^\/]+\/)*[^\/]*/) do |path|
  Dir["#{path}*"]
end
