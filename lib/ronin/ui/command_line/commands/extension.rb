#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/ui/command_line/command'
require 'ronin/cache/extension'
require 'ronin/config'

require 'fileutils'
require 'erb'

module Ronin
  module UI
    module CommandLine
      class ExtensionCommand < Command

        command :extension, :ext

        def initialize
          @uses = []

          super
        end

        def define_options(opts)
          opts.usage = '[options] PATH'

          opts.options do
            opts.on('-u','--uses NAME','Name of an other extension to use') do |name|
              @uses << name
            end
          end

          opts.arguments(
            'PATH' => 'The PATH of the Extension to be created'
          )

          opts.summary('Create an empty Extension at the specified PATH')
        end

        def arguments(*args)
          unless args.length == 1
            fail('only one Extension path maybe specified')
          end

          path = File.expand_path(args.first)

          FileUtils.mkdir_p(path)
          FileUtils.mkdir_p(File.join(path,'lib'))
          FileUtils.touch(File.join(path,'lib',File.basename(path) + '.rb'))

          File.open(File.join(path,Cache::Extension::EXTENSION_FILE),'w') do |file|
            template_path = File.join(Config::STATIC_DIR,'templates','extension.rb.erb')
            template = ERB.new(File.new(template_path))

            file.write(template.result(binding))
          end
        end

      end
    end
  end
end
