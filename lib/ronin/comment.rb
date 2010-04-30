#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/url'
require 'ronin/model'

require 'dm-timestamps'

module Ronin
  class Comment

    include Model
    include DataMapper::Timestamps

    # Primary key of the comment
    property :id, Serial

    # The body of the comment
    property :body, Text, :required => true

    # The address the comment was added to
    belongs_to :address, :required => false

    # The open-port the comment was added to
    belongs_to :open_port, :required => false

    # The URL the comment was added to
    belongs_to :url, :required => false, :model => 'URL'

    # Define the created_at and updated_at timestamps
    timestamps :at

    validates_with_method :check_comment_associations

    #
    # A DataMapper validation method that makes sure the comment has only
    # one association.
    #
    # @return [Boolean, Array]
    #   Returns `true` if the comment is valid, or an `Array` if the
    #   comment has no associations or more than one.
    #
    def check_comment_associations
      fields = [:address, :open_port, :url]
      all_nil = fields.all? { |name| self.send(name).nil? }

      if all_nil
        return [false, "Comment must be associated with atleast one Host, OpenPort, Site or URL"]
      end

      not_nils = fields.select { |name| self.send(name) }

      if not_nils.length > 1
        return [false, "Comment has more then one association: #{fields.join(' ')}"]
      end

      return true
    end

    #
    # Converts the comment to a string.
    #
    # @return [String]
    #   The body of the comment.
    #
    def to_s
      self.body.to_s
    end

  end
end
