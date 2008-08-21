module Ronin
  class Shell

    # Default shell prompt
    DEFAULT_PROMPT = '>'

    # Shell name to use
    attr_accessor :name

    # Shell prompt
    attr_accessor :prompt

    #
    # Creates a new Shell object with the given _options_. If a _block_ is
    # given it will be passed the newly created Shell object.
    #
    # _options_ may contain the following keys:
    # <tt>:name</tt>:: The name of the shell.
    # <tt>:prompt</tt>::The prompt to use for the shell.
    #
    def initialize(options={},&block)
      @name = options[:name]
      @prompt = (options[:prompt] || DEFAULT_PROMPT)

      block.call(self) if block
    end

    #
    # Creates and starts a new Shell object with the specified _options_.
    # If a _block_ is given, it will be passed the newly created Shell
    # object before it is started.
    #
    def self.start(options={},&block)
      self.new(options,&block).start
    end

    #
    # Starts the shell.
    #
    def start
      history_rollback = 0

      loop do
        line = Readline.readline("#{@name}#{@prompt} ")

        if line =~ /^\s*exit\s*$/
          exit_shell
          break
        else
          Readline::HISTORY << line
          history_rollback += 1

          begin
            process_command(line)
          rescue => e
            puts "#{e.class.name}: #{e.message}"
          end
        end
      end

      history_rollback.times do
        Readline::HISTORY.pop
      end

      return nil
    end

    #
    # Default method that processes commands.
    #
    def process_command(command)
    end

    #
    # Default method that will be called when the shell is exited.
    #
    def exit_shell
    end

  end
end
