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

require 'ronin/ui/command_line/command'
require 'ronin/platform/overlay'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Install < Command

          desc 'Installs the Overlay located at the specified URI'
          class_option :cache, :type => :string, :aliases => '-C'
          class_option :scm, :type => :string, :aliases => '-S'
          class_option :rsync, :type => :boolean
          class_option :svn, :type => :boolean
          class_option :hg, :type => :boolean
          class_option :git, :type => :boolean
          arugment :uri, :type => :string

          def execute
            if options[:cache]
              Platform.load_overlays(options[:cache])
            end

            scm = if options[:scm]
                      options[:scm].to_sym
                    elsif options.rsync?
                      :rsync
                    elsif options.svn?
                      :sub_version
                    elsif options.hg?
                      :mercurial
                    elsif options.git?
                      :git
                    end

            begin
              Platform.install(:uri => uri, :scm => scm) do |overlay|
                print_info "Overlay #{overlay.name.dump} has been installed."
              end
            rescue Platform::OverlayCached => e
              print_error e.message
              exit -1
            end
          end

        end
      end
    end
  end
end
