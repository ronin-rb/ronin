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

require 'ronin/database/migrations/migrations'
require 'ronin/database/migrations/create_arches_table'
require 'ronin/database/migrations/create_os_table'
require 'ronin/database/migrations/create_vendors_table'
require 'ronin/database/migrations/create_softwares_table'
require 'ronin/database/migrations/create_licenses_table'
require 'ronin/database/migrations/create_authors_table'
require 'ronin/database/migrations/create_addresses_table'
require 'ronin/database/migrations/create_ports_table'
require 'ronin/database/migrations/create_ip_address_mac_addresses_table'
require 'ronin/database/migrations/create_host_name_ip_addresses_table'
require 'ronin/database/migrations/create_proxies_table'
require 'ronin/database/migrations/create_services_table'
require 'ronin/database/migrations/create_open_ports_table'
require 'ronin/database/migrations/create_os_guesses_table'
require 'ronin/database/migrations/create_url_schemes_table'
require 'ronin/database/migrations/create_url_query_params_table'
require 'ronin/database/migrations/create_urls_table'
require 'ronin/database/migrations/create_user_names_table'
require 'ronin/database/migrations/create_email_addresses_table'
require 'ronin/database/migrations/create_passwords_table'
require 'ronin/database/migrations/create_credentials_table'
require 'ronin/database/migrations/create_countries_table'
require 'ronin/database/migrations/create_organizations_table'
require 'ronin/database/migrations/create_campaigns_table'
require 'ronin/database/migrations/create_targets_table'
require 'ronin/database/migrations/create_cached_files_table'
require 'ronin/database/migrations/create_repositories_table'

require 'ronin/database/database'

Ronin::Database.upgrade!
