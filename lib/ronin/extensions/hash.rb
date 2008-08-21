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

class Hash

  #
  # Explodes the hash into a Hash of hashes using the given _options_, where
  # each Hash has the value of one key replaced with the specified _value_.
  # If a _block_ is given, it will be passed each key that was replaced and
  # the resulting Hash.
  #
  # _options_ may contain the following keys:
  # <tt>:included</tt>:: The keys whos values are to be replaced.
  # <tt>:excluded</tt>:: The keys whos values will not be replaced.
  #
  #   hash = {:a => 1, :b => 2}
  #   hash.explode('z')
  #   # => {:a=>{:a=>"z", :b=>2}, :b=>{:a=>1, :b=>"z"}}
  #
  #   hash = {:a => 1, :b => 2, :c => 3}
  #   hash.explode('z', :excluded => [:b])
  #   # => {:c=>{:c=>"z", :a=>1, :b=>2}, :a=>{:c=>3, :a=>"z", :b=>2}}
  #
  def explode(value,options={},&block)
    included = (options[:included] || keys)
    excluded = (options[:excluded] || [])
    selected_keys = included - excluded

    hashes = {}

    selected_keys.each do |key|
      new_hash = clone
      new_hash[key] = value

      block.call(key,new_hash) if block
      hashes[key] = new_hash
    end

    return hashes
  end

end
