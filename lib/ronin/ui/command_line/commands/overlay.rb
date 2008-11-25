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
require 'ronin/cache/overlay'
require 'ronin/version'

require 'fileutils'
require 'rexml/document'

module Ronin
  module UI
    module CommandLine
      class OverlayCommand < Command

        include REXML

        command :overlay

        def initialize
          @name = nil
          @license = nil
          @url = nil
          @description = nil
          @authors = []

          super
        end

        def define_options(opts)
          opts.usage = '[options] PATH'

          opts.options do
            opts.on('-n','--name NAME','Name of the Overlay') do |name|
              @name = name
            end

            opts.on('-L','--license LICENSE','The license of the contents of the Overlay') do |license|
              @license = license
            end

            opts.on('-U','--url URL','The URL where the Overlay will be hosted from') do |url|
              @url = url
            end

            opts.on('-D','--description TEXT','The description for the Overlay') do |text|
              @description = text
            end

            opts.on('-a','--author NAME','Name of a contributing author to the Overlay') do |name|
              @authors << name
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

          @name ||= File.basename(path)

          FileUtils.mkdir_p(path)
          FileUtils.mkdir_p(File.join(path,'objects'))

          File.open(File.join(path,Cache::Overlay::METADATA_FILE),'w') do |file|
            doc = Document.new
            doc.add(XMLDecl.new)

            root = Element.new('ronin-overlay')
            root.attributes['version'] = Ronin::VERSION

            name_tag = Element.new('name')
            name_tag.text = @name
            root.add_element(name_tag)

            if @license
              license_tag = Element.new('license')
              license_tag.text = @license
              root.add_element(license_tag)
            end

            if @url
              url_tag = Element.new('url')
              url_tag.text = @url
              root.add_element(url_tag)
            end

            if @description
              description_tag = Element.new('description')
              description_tag.text = @description
              root.add_element(description_tag)
            end

            unless @authors.empty?
              authors_tag = Element.new('authors')

              @authors.each do |author|
                name_tag = Element.new('name')
                name_tag.text = author
                authors_tag.add_element(name_tag)
              end

              root.add_element(authors_tag)
            end

            doc.add_element(root)
            doc.write(file,2)
          end
        end

      end
    end
  end
end
