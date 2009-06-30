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

module Kernel
  #
  # Calls the given _block_ and ignores any raised exceptions.
  # If an exception is raised, +nil+ will be returned.
  #
  #   try do
  #     Resolv.getaddress('might.not.exist.com')
  #   end
  #
  def try(&block)
    begin
      block.call if block
    rescue Exception
      return nil
    end
  end

  #
  # Attempts to run the given _block_ and catches any SyntaxError,
  # RuntimeError or StandardError exceptions. If any exceptions are
  # caught, they will be printed out and +nil+ will be returned.
  #
  #   catch_all do
  #     load 'suspicious.rb'
  #   end
  #
  def catch_all(verbose=true,&block)
    begin
      block.call if block
    rescue Exception => e
      if verbose
        STDERR.puts "#{e.class}: #{e}"
        e.backtrace[0,5].each { |trace| STDERR.puts "\t#{trace}" }
      end

      return nil
    end
  end
end
