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
require 'ronin/engine'

module Ronin
  module UI
    module CLI
      class EngineCommand < ModelCommand

        class_option :file, :type => :string, :aliases => '-f'

        query_option :name, :type => :string,
                            :aliases => '-n',
                            :method => :named

        query_option :describing, :type => :string, :aliases => '-d'

        query_option :version, :type => :string,
                               :aliases => '-V',
                               :method => :revision

        query_option :license, :type => :string,
                               :aliases => '-L',
                               :method => :licensed_under

        #
        # The class to load engines from.
        #
        # @return [Engine]
        #   The engine class.
        #
        # @since 1.0.0
        #
        def self.engine_class
          model
        end

        protected

        #
        # Defines the class to load engines from.
        #
        # @param [Engine] engine
        #   The engine class.
        #
        # @return [Engine]
        #   The new engine class.
        #
        # @raise [ArgumentError]
        #   The given engine class does not include {Ronin::Engine}.
        #
        # @since 1.0.0
        #
        def self.engine_class=(engine)
          unless engine.included_modules.include?(Engine)
            raise(ArgumentError,"#{engine} does not include Ronin::Engine")
          end

          self.model = engine
        end

        #
        # Loads an engine using the commands options.
        #
        # @return [Engine, nil]
        #   The newly loaded engine.
        #
        # @raise [RuntimeError]
        #   The engine class did not define the query method for one of the
        #   query options.
        #
        # @since 1.0.0
        #
        def load_engine
          if options[:file]
            self.class.engine_class.load_from(options[:file])
          else
            new_query.load_first
          end
        end

      end
    end
  end
end
