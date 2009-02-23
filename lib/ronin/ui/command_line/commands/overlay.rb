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
require 'nokogiri'

module Ronin
  module UI
    module CommandLine
      module Commands
        class Overlay < Command

          include Nokogiri

          def defaults
            @title = nil
            @source = nil
            @source_view = nil
            @website = nil
            @license = nil
            @maintainers = []
            @description = nil
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
              doc = XML::Document.new
              doc << XML::ProcessingInstruction.new(
                doc,
                'xml-stylesheet',
                'type="text/xsl" href="http://ronin.rubyforge.org/dist/overlay.xsl"'
              )

              root = XML::Node.new('ronin-overlay',doc)
              root['version'] = Ronin::VERSION

              title_tag = XML::Node.new('title',doc)
              title_tag << XML::Text.new(@title,doc)
              root << title_tag

              if @source
                source_tag = XML::Node.new('source',doc)
                source_tag << XML::Text.new(@source,doc)
                root << source_tag
              end

              if @source_view
                source_view_tag = XML::Node.new('source-view',doc)
                source_view_tag << XML::Text.new(@source_view,doc)
                root << source_view_tag
              end

              if @website
                url_tag = XML::Node.new('website',doc)
                url_tag << XML::Text.new(@website,doc)
                root << url_tag
              end

              if @license
                license_tag = XML::Node.new('license',doc)
                license_tag << XML::Text.new(@license,doc)
                root << license_tag
              end

              unless @maintainers.empty?
                maintainers_tag = XML::Node.new('maintainers',doc)

                @maintainers.each do |author|
                  if (author[:name] || author[:email])
                    maintainer_tag = XML::Node.new('maintainer',doc)

                    if author[:name]
                      name_tag = XML::Node.new('name',doc)
                      name_tag << XML::Text.new(author[:name],doc)
                      maintainer_tag << name_tag
                    end

                    if author[:email]
                      email_tag = XML::Node.new('email',doc)
                      email_tag << XML::Text.new(author[:email],doc)
                      maintainer_tag << email_tag
                    end

                    maintainers_tag << maintainer_tag
                  end
                end

                root << maintainers_tag
              end

              if @description
                description_tag = XML::Node.new('description',doc)
                description_tag << XML::Text.new(@description,doc)
                root << description_tag
              end

              doc << root
              doc.write_xml_to(file)
            end
          end

        end
      end
    end
  end
end
