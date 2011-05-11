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

require 'ronin/ui/cli/model_command'
require 'ronin/ui/console'
require 'ronin/script'

module Ronin
  module UI
    module CLI
      #
      # A base-command for querying and loading {Script}s.
      #
      class ScriptCommand < ModelCommand

        query_option :named, :type => :string, :aliases => '-n'
        query_option :describing, :type => :string, :aliases => '-d'
        query_option :revision, :type => :string, :aliases => '-V'
        query_option :licensed_under, :type => :string, :aliases => '-L'

        class_option :file, :type => :string, :aliases => '-f'
        class_option :params, :type => :hash,
                              :default => {},
                              :banner => 'NAME:VALUE ...',
                              :aliases => '-p'
        class_option :console, :type => :boolean, :default => false

        #
        # The class to load scripts from.
        #
        # @return [Script]
        #   The script class.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.script_class
          model
        end

        #
        # Loads the script, sets its parameters and runs the script.
        #
        # @since 1.0.0.
        #
        # @api semipublic
        #
        def execute
          script = load_script
          script.params = options[:params]

          if options.console?
            print_info "Starting the console with @script set ..."

            UI::Console.start(:script => script)
          else
            script.run
          end
        end

        protected

        #
        # Defines the class to load scripts from.
        #
        # @param [Script] script
        #   The script class.
        #
        # @return [Script]
        #   The new script class.
        #
        # @raise [ArgumentError]
        #   The given script class does not include {Ronin::Script}.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def self.script_class=(script)
          unless script.included_modules.include?(Script)
            raise(ArgumentError,"#{script} does not include Ronin::Script")
          end

          self.model = script
        end

        #
        # Loads an script using the commands options.
        #
        # @return [Script, nil]
        #   The newly loaded script.
        #
        # @raise [RuntimeError]
        #   The script class did not define the query method for one of the
        #   query options.
        #
        # @since 1.0.0
        #
        # @api semipublic
        #
        def load_script
          if options[:file]
            self.class.script_class.load_from(options[:file])
          else
            query.load_first
          end
        end

      end
    end
  end
end
