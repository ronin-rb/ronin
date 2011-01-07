#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'thread'

module Ronin
  module UI
    class AsyncConsole

      # The result message class
      Result = Struct.new(:line, :type, :value)

      #
      # Creates a new Asynchronous Console, within the given context.
      #
      # @param [Module] context
      #   The context to evaluate code within.
      #
      # @yield []
      #   If a block is given, it will be instance evaled within the
      #   sandbox object.
      #
      def initialize(context=Ronin,&block)
        @context = context
        @line = 0

        @input = Queue.new
        @output = Queue.new

        sandbox = Object.new
        sandbox.extend context
        sandbox.instance_eval(&block) if block

        Thread.new(sandbox) do |sandbox|
          scope = sandbox.send :binding

          loop do
            line, code = @input.pop

            begin
              result = if code.kind_of?(Proc)
                         sandbox.instance_eval(&code)
                       else
                         eval(code,scope)
                       end

              mesg = Result.new(line, :object, result)
            rescue Exception => e
              mesg = Result.new(line, :exception, e)
            end

            @output.push mesg
          end
        end
      end

      #
      # Enqueues Ruby code or a block to be evaluated.
      #
      # @param [String] code
      #   The Ruby code to evaluate.
      #
      # @yield []
      #   If a block is given, it will be evaluated.
      #
      # @return [Integer]
      #   The line number assigned to the pushed code.
      #
      def push(code=nil,&block)
        @input.push [@line += 1, (code || block)]
        return @line
      end

      #
      # Determines whether the output queue is empty.
      #
      # @return [Boolean]
      #   The state of the output queue.
      #
      def empty?
        @output.empy?
      end

      #
      # Dequeues a result.
      #
      # @return [Result]
      #   The result message.
      #
      def pull
        @output.pop unless @output.empty?
      end

      #
      # Enumerates over the results in the output queue.
      #
      # @yield [message]
      #   The given block will be passed each result.
      #
      # @yieldparam [Result] message
      #   A result message returned from a previous evaluation.
      #
      def each
        until @output.empty?
          yield @output.pop
        end

        return self
      end

    end
  end
end
