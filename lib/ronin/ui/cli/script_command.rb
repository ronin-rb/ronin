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

require 'parameters/options'

module Ronin
  module UI
    module CLI
      #
      # A base-command for querying and loading {Script}s.
      #
      class ScriptCommand < ModelCommand

        usage '[options] -- SCRIPT_ARGS ...'

        query_option :named, :type  => String,
                             :flag  => '-n',
                             :usage => 'NAME'

        query_option :describing, :type  => String,
                                  :flag  => '-d',
                                  :usage => 'DESC'

        query_option :revision, :type  => String,
                                :flag  => '-V',
                                :usage => 'REV'

        query_option :licensed_under, :type  => String,
                                      :flag  => '-L',
                                      :usage => 'LICENSE'

        option :file, :type  => String,
                      :flag  => '-f',
                      :usage => 'FILE'

        option :console, :type => true

        argument :script_args, :type        => Array,
                               :default     => [],
                               :description => 'Additional script arguments'

        #
        # Loads the script, sets its parameters and runs the script.
        #
        # @since 1.1.0.
        #
        # @api semipublic
        #
        def execute
          script = load_script

          script_opts = Parameters::Options.parser(script)
          script_opts.parse(@script_args)

          if @console
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
        # @since 1.1.0
        #
        # @api semipublic
        #
        def self.script_class(script)
          unless script.included_modules.include?(Script)
            raise(ArgumentError,"#{script} does not include Ronin::Script")
          end

          model(script)
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
        # @since 1.1.0
        #
        # @api semipublic
        #
        def load_script
          if @file
            self.class.model.load_from(@file)
          else
            query.load_first
          end
        end

      end
    end
  end
end
