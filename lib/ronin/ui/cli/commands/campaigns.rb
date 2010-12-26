#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/cli/model_command'
require 'ronin/campaign'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin-campaigns` command.
        #
        class Campaigns < ModelCommand

          self.model = Campaign 

          query_option :name, :type => :string,
                              :aliases => '-n',
                              :method => :named

          query_option :description, :type => :string, :aliases => '-d'

          query_option :addresses, :type => :array, :aliases => '-A' do |campaigns,addresses|
            campaigns.all('addresses.address' => addresses)
          end

          query_option :organizations, :type => :array, :aliases => '-O' do |campaigns,orgs|
            campaigns.all('organizations.name' => orgs)
          end

          class_option :list, :type => :boolean,
                              :default => true,
                              :aliases => '-l'

          class_option :add, :type => :string,
                             :aliases => '-a',
                             :banner => 'NAME'

          #
          # Queries the {Campaign} model.
          #
          # @since 1.0.0
          #
          def execute
            if options[:add]
              add options[:add]
            elsif options.list?
              super
            end
          end

          protected

          #
          # Adds a new campaign.
          #
          # @param [String] name
          #   The name of the new campaign.
          #
          # @since 1.0.0
          #
          def add(name)
            campaign = Campaign.new(:name => name)

            if campaign.save
              print_info "Added campaign #{campaign}"
            else
              print_error "Could not add campaign #{name.dump}."
            end
          end

          #
          # Prints a campaign.
          #
          # @param [Campaign] campaign
          #   The campaign to print.
          #
          # @since 1.0.0
          #
          def print_resource(campaign)
            return super(campaign) unless options.verbose?

            print_title campaign.name

            indent do
              if campaign.description
                print_section 'Description' do
                  campaign.description.each_line do |line|
                    puts line
                  end
                end
              end

              unless campaign.organizations.empty?
                print_array campaign.organizations, :title => 'Targeted Organizations'
              end

              unless campaign.targets.empty?
                print_array campaign.targets, :title => 'Targets'
              end
            end
          end

        end
      end
    end
  end
end
