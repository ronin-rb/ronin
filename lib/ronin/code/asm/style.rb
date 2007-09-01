#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

module Ronin
  module Code
    module ASM
      class Style

        # ASM Dialect to use
        attr_reader :dialect

        # ASM Syntax to use
        attr_accessor :syntax

        def initialize(dialect,syntax=:att)
          @dialect = dialect
          @syntax = syntax
        end

        def compile_integer(data,format=:hex)
          case format
          when :hex, :hexidecimal
            if @style==:att
              return format("$0x%x",data)
            elsif @style==:intel
              hex = format("%xh",data)
              if hex[0..0] =~ /[a-f]/
                hex = "0#{hex}"
              end

              return hex
            end
          when :dec, :decimal
            if @style==:att
              return format("$%d",data)
            elsif @style==:intel
              return format("%d",data)
            end
          when :oct, :octal
            if @style==:att
              return format("$0%o",data)
            elsif @style==:intel
              return format("0%o",data)
            end
          when :bin, :binary
            if @style==:att
              return format("$0b%b",data)
            elsif @style==:intel
              return format("%bb",data)
            end
          end
        end

        def compile_string(str)
          str.to_s.dump
        end

      end
    end
  end
end
