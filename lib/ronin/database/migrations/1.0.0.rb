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

module Ronin
  module Database
    module Migrations
      migration :create_addresses_table,
                :needs => :create_organizations_table do
        up do
          create_table :ronin_addresses do
            column :id, Integer, :serial => true
            column :type, String, :not_null => true
            column :version, Integer
            column :address, String, :length => 256, :not_null => true
            column :organization_id, Integer
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_addresses, :address, :unique => true
        end

        down do
          drop_table :ronin_addresses
        end
      end

      migration :create_arches_table do
        up do
          create_table :ronin_arches do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :endian, String, :not_null => true
            column :address_length, Integer, :not_null => true
          end

          create_index :ronin_arches, :name, :unique => true
        end

        down do
          drop_table :ronin_arches
        end
      end

      migration :create_authors_table do
        up do
          create_table :ronin_authors do
            column :id, Integer, :serial => true
            column :name, String
            column :organization, String
            column :pgp_signature, String
            column :email, String
            column :site, String
            column :biography, Text
          end

          create_index :ronin_authors, :name
        end

        down do
          drop_table :ronin_authors
        end
      end

      migration :create_campaigns_table do
        up do
          create_table :ronin_campaigns do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :description, Text, :not_null => true
            column :created_at, Time
          end

          create_index :ronin_campaigns, :name, :unique => true
        end

        down do
          drop_table :ronin_campaigns
        end
      end

      migration :create_countries_table do
        up do
          create_table :ronin_countries do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :code, String, :length => 2, :not_null => true
          end

          create_index :ronin_countries, :name, :unique => true
          create_index :ronin_countries, :code, :unique => true
        end

        down do
          drop_table :ronin_countries
        end
      end

      migration :create_credentials_table,
                :needs => [
                  :create_user_names_table,
                  :create_passwords_table,
                  :create_open_ports_table,
                  :create_urls_table,
                  :create_proxies_table
                ] do
        up do
          create_table :ronin_credentials do
            column :id, Serial
            column :user_name_id, Integer, :not_null => true
            column :password_id, Integer, :not_null => true

            column :open_port_id, Integer
            column :email_address_id, Integer
            column :url_id, Integer
          end

          create_index :ronin_credentials,
                       :user_name_id, :password_id,
                       :open_port_id, :email_address_id, :url_id,
                       :name => :unique_index_ronin_credentials,
                       :unique => true
        end

        down do
          drop_table :ronin_credentials
        end
      end

      migration :create_email_addresses_table,
                :needs => [
                  :create_user_names_table,
                  :create_addresses_table
                ] do
        up do
          create_table :ronin_email_addresses do
            column :id, Serial
            column :user_name_id, Integer, :not_null => true
            column :host_name_id, Integer, :not_null => true
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_email_addresses, :user_name_id, :host_name_id,
                       :name => :unique_index_ronin_email_addresses,
                       :unique => true
        end

        down do
          drop_table :ronin_email_addresses
        end
      end

      migration :create_host_name_ip_addresses_table,
                :needs => :create_addresses_table do
        up do
          create_table :ronin_host_name_ip_addresses do
            column :id, Serial
            column :host_name_id, Integer, :not_null => true
            column :ip_address_id, Integer, :not_null => true
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_host_name_ip_addresses,
                       :host_name_id, :ip_address_id,
                       :name => :unique_index_ronin_host_name_ip_addresses,
                       :unique => true
        end

        down do
          drop_table :ronin_host_name_ip_addresses
        end
      end

      migration :create_ip_address_mac_addresses_table,
                :needs => :create_addresses_table do
        up do
          create_table :ronin_ip_address_mac_addresses do
            column :id, Serial
            column :ip_address_id, Integer, :not_null => true
            column :mac_address_id, Integer, :not_null => true
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_ip_address_mac_addresses,
                       :ip_address_id, :mac_address_id,
                       :name => :unique_index_ronin_ip_address_mac_addresses,
                       :unique => true
        end

        down do
          drop_table :ronin_ip_address_mac_addresses
        end
      end

      migration :create_licenses_table do
        up do
          create_table :ronin_licenses do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :description, Text, :not_null => true
            column :url, String, :length => 256
          end

          create_index :ronin_licenses, :name, :unique => true
        end

        down do
          drop_table :ronin_licenses
        end
      end

      migration :create_open_ports_table,
                :needs => [
                  :create_addresses_table,
                  :create_ports_table,
                ] do
        up do
          create_table :ronin_open_ports do
            column :id, Integer, :serial => true
            column :ip_address_id, Integer, :not_null => true
            column :port_id, Integer, :not_null => true
            column :service_id, Integer
            column :last_scanned_at, Time
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_open_ports,
                       :ip_address_id, :port_id, :service_id,
                       :name => :unique_index_ronin_open_ports,
                       :unique => true
        end

        down do
          drop_table :ronin_open_ports
        end
      end

      migration :create_organizations_table do
        up do
          create_table :ronin_organizations do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :description, Text, :not_null => true
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_organizations, :name, :unique => true
        end

        down do
          drop_table :ronin_organizations
        end
      end

      migration :create_os_guesses_table,
                :needs => [
                  :create_addresses_table,
                  :create_os_table
                ] do
        up do
          create_table :ronin_os_guesses do
            column :id, Serial
            column :ip_address_id, Integer, :not_null => true
            column :os_id, Integer, :not_null => true
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_os_guesses, :ip_address_id, :os_id,
                       :name => :unique_index_ronin_os_guesses,
                       :unique => true
        end

        down do
          drop_table :ronin_os_guesses
        end
      end

      migration :create_os_table do
        up do
          create_table :ronin_os do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :version, String
          end

          create_index :ronin_os, :name
          create_index :ronin_os, :version
        end

        down do
          drop_table :ronin_os
        end
      end

      migration :create_passwords_table do
        up do
          create_table :ronin_passwords do
            column :id, Integer, :serial => true
            column :clear_text, String, :length => 256, :not_null => true
          end

          create_index :ronin_passwords, :clear_text, :unique => true
        end

        down do
          drop_table :ronin_passwords
        end
      end

      migration :create_ports_table, :needs => :create_organizations_table do
        up do
          create_table :ronin_ports do
            column :id, Integer, :serial => true
            column :protocol, String, :not_null => true
            column :number, Integer, :not_null => true
            column :organization_id, Integer
          end

          create_index :ronin_ports, :protocol, :number, :name => :protocol_number, :unique => true
        end

        down do
          drop_table :ronin_ports
        end
      end

      migration :create_proxies_table,
                :needs => [
                  :create_addresses_table,
                  :create_ports_table
                ] do
        up do
          create_table :ronin_proxies do
            column :id, Integer, :serial => true
            column :type, String, :not_null => true
            column :anonymous, Boolean, :default => false
            column :latency, Float
            column :alive, Boolean, :default => true
            column :ip_address_id, Integer, :not_null => true
            column :port_id, Integer, :not_null => true
            column :created_at, DateTime
            column :updated_at, DateTime
          end
        end

        down do
          drop_table :ronin_proxies
        end
      end

      migration :create_repositories_table, :needs => :create_licenses_table do
        up do
          create_table :ronin_repositories do
            column :id, Integer, :serial => true
            column :scm, String
            column :path, FilePath, :not_null => true 
            column :uri, DataMapper::Property::URI
            column :installed, Boolean, :default => false
            column :name, String
            column :domain, String, :not_null => true
            column :title, Text
            column :source, DataMapper::Property::URI
            column :website, DataMapper::Property::URI
            column :description, Text

            column :license_id, Integer
          end

          create_table :ronin_author_repositories do
            column :id, Integer, :serial => true
            column :author_id, Integer
            column :repository_id, Integer
          end

          create_index :ronin_repositories, :path, :unique => true
        end

        down do
          drop_table :ronin_author_repositories
          drop_table :ronin_repositories
        end
      end

      migration :create_script_paths_table,
                :needs => :create_repositories_table do
        up do
          create_table :ronin_script_paths do
            column :id, Integer, :serial => true
            column :path, FilePath, :not_null => true
            column :timestamp, Time, :not_null => true
            column :class_name, String, :not_null => true
            column :repository_id, Integer, :not_null => true
          end
        end

        down do
          drop_table :ronin_script_paths
        end
      end

      migration :create_services_table,
                :needs => :create_organizations_table do
        up do
          create_table :ronin_services do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :organization_id, Integer
          end

          create_index :ronin_services, :name, :unique => true
        end

        down do
          drop_table :ronin_services
        end
      end

      migration :create_softwares_table,
                :needs => :create_vendors_table do
        up do
          create_table :ronin_softwares do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :version, String, :not_null => true
            column :vendor_id, Integer
          end

          create_index :ronin_softwares, :name
          create_index :ronin_softwares, :version
        end

        down do
          drop_table :ronin_arches
        end
      end

      migration :create_targets_table,
                :needs => [
                  :create_campaigns_table,
                  :create_addresses_table
                ] do
        up do
          create_table :ronin_targets do
            column :id, Integer, :serial => true
            column :campaign_id, Integer, :not_null => true
            column :address_id, Integer, :not_null => true
          end

          create_index :ronin_targets, :campaign_id, :address_id,
                       :name => :unique_index_ronin_campaigns,
                       :unique => true
        end

        down do
          drop_table :ronin_targets
        end
      end

      migration :create_url_query_params_table do
        up do
          create_table :ronin_url_query_params do
            column :id, Integer, :serial => true
            column :name, String, :length => 256, :not_null => true
            column :value, Text
            column :url_id, Integer, :not_null => true
          end
        end

        down do
          drop_table :ronin_url_query_params
        end
      end

      migration :create_url_schemes_table do
        up do
          create_table :ronin_url_schemes do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
          end
        end

        down do
          drop_table :ronin_url_schemes
        end
      end

      migration :create_urls_table,
                :needs => [
                  :create_url_schemes_table,
                  :create_url_query_params_table,
                  :create_addresses_table,
                  :create_ports_table
                ] do
        up do
          create_table :ronin_urls do
            column :id, Integer, :serial => true
            column :scheme_id, Integer, :not_null => true
            column :host_name_id, Integer, :not_null => true
            column :port_id, Integer
            column :path, String
            column :fragment, String
            column :last_scanned_at, Time
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_urls, :scheme_id,
                                    :host_name_id,
                                    :port_id,
                                    :path,
                                    :fragment,
                                    :name => :unique_index_ronin_urls,
                                    :unique => true
        end

        down do
          drop_table :ronin_urls
        end
      end

      migration :create_user_names_table do
        up do
          create_table :ronin_user_names do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
            column :created_at, Time, :not_null => true
          end

          create_index :ronin_user_names, :name, :unique => true
        end

        down do
          drop_table :ronin_user_names
        end
      end

      migration :create_vendors_table do
        up do
          create_table :ronin_vendors do
            column :id, Integer, :serial => true
            column :name, String, :not_null => true
          end

          create_index :ronin_vendors, :name, :unique => true
        end

        down do
          drop_table :ronin_vendors
        end
      end
    end
  end
end
