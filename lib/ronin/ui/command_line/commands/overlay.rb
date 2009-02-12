#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/platform/overlay'
require 'ronin/version'

require 'fileutils'
require 'rexml/document'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Overlay < Command

          include REXML

          def initialize(name)
            @title = nil
            @source = nil
            @source_view = nil
            @website = nil
            @license = nil
            @maintainers = []
            @description = nil

            super(name)
          end

          def define_options(opts)
            opts.usage = '[options] PATH'

            opts.options do
              opts.on('-t','--title NAME','Name of the Overlay') do |title|
                @title = title
              end

              opts.on('-S','--source URL','The URL where the source of the Overlay will be hosted') do |url|
                @source = url
              end

              opts.on('-V','--source-view URL','The URL for viewing the contents of the Overlay') do |url|
                @source_view = url
              end

              opts.on('-U','--website URL','The URL of the website of the Overlay') do |url|
                @website = url
              end

              opts.on('-L','--license LICENSE','The license of the contents of the Overlay') do |license|
                @license = license
              end

              opts.on('-m','--maintainer "NAME <EMAIL>"','Name of a maintainer of the Overlay') do |text|
                name = text.scan(/^[^<]+[^<\s]/).first
                email = text.scan(/<([^<>]+)>\s*$/).first

                email = email.first if email

                @maintainers << {:name => name, :email => email}
              end

              opts.on('-D','--description TEXT','The description for the Overlay') do |text|
                @description = text
              end
            end

            opts.arguments(
              'PATH' => 'The PATH of the Overlay to be created'
            )

            opts.summary('Create an empty Overlay at the specified PATH')
          end

          def arguments(*args)
            unless args.length == 1
              fail('only one Overlay path maybe specified')
            end

            path = File.expand_path(args.first)

            @title ||= File.basename(path).gsub(/[_\s]+/,' ').capitalize
            @source_view ||= @source
            @website ||= @source_view

            FileUtils.mkdir_p(path)
            FileUtils.mkdir_p(File.join(path,'lib'))
            FileUtils.mkdir_p(File.join(path,'objects'))

            File.open(File.join(path,Platform::Overlay::METADATA_FILE),'w') do |file|
              doc = Document.new
              doc.add(XMLDecl.new)
              doc.add(Instruction.new('xml-stylesheet','type="text/xsl" href="http://ronin.rubyforge.org/dist/overlay.xsl"'))

              root = Element.new('ronin-overlay')
              root.attributes['version'] = Ronin::VERSION

              title_tag = Element.new('title')
              title_tag.text = @title
              root.add_element(title_tag)

              if @source
                source_tag = Element.new('source')
                source_tag.text = @source
                root.add_element(source_tag)
              end

              if @source_view
                source_view_tag = Element.new('source-view')
                source_view_tag.text = @source_view
                root.add_element(source_view_tag)
              end

              if @website
                url_tag = Element.new('website')
                url_tag.text = @website
                root.add_element(url_tag)
              end

              if @license
                license_tag = Element.new('license')
                license_tag.text = @license
                root.add_element(license_tag)
              end

              unless @maintainers.empty?
                maintainers_tag = Element.new('maintainers')

                @maintainers.each do |author|
                  if (author[:name] || author[:email])
                    maintainer_tag = Element.new('maintainer')

                    if author[:name]
                      name_tag = Element.new('name')
                      name_tag.text = author[:name]
                      maintainer_tag.add_element(name_tag)
                    end

                    if author[:email]
                      email_tag = Element.new('email')
                      email_tag.text = author[:email]
                      maintainer_tag.add_element(email_tag)
                    end

                    maintainers_tag.add_element(maintainer_tag)
                  end
                end

                root.add_element(maintainers_tag)
              end

              if @description
                description_tag = Element.new('description')
                description_tag.text = @description
                root.add_element(description_tag)
              end

              doc.add_element(root)
              doc.write(file,2)
            end
          end

        end
      end
    end
  end
end
