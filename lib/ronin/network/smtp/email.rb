#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Network
    module SMTP
      class Email

        # Sender of the email
        attr_accessor :from

        # Recipient of the email
        attr_accessor :to

        # Subject of the email
        attr_accessor :subject

        # Date of the email
        attr_accessor :date

        # Unique message-id string
        attr_accessor :message_id

        # Body of the email

        def initialize(options={},&block)
          @from = options[:from]
          @to = options[:to]
          @subject = options[:subject]
          @date = options[:date] || Time.now
          @message_id = options[:message_id]
          @body = []

          if options[:body].kind_of?(Array)
            @body += options[:body]
          else
            @body << options[:body]
          end

          block.call(self) if block
        end

        #
        # Formats the email into a SMTP message as described in
        # http://www.ruby-doc.org/stdlib/libdoc/net/smtp/rdoc/classes/Net/SMTP.html
        #
        def to_s
          address = lambda { |info|
            if info.kind_of?(Array)
              return "#{info[0]} <#{info[1]}>"
            elsif info.kind_of?(Hash)
              return "#{info[:name]} <#{info[:email]}>"
            else
              return info
            end
          }

          message = []

          if @from
            message << "From: #{address.call(@from)}"
          end

          if @to
            message << "To: #{address.call(@to)}"
          end

          if @subject
            message << "Subject: #{@subject}"
          end

          if @date
            message << "Date: #{@date}"
          end

          if @message_id
            message << "Message-Id: <#{@message_id}>"
          end

          message << ''
          message += @body

          return message.join("\n")
        end

      end
    end
  end
end
