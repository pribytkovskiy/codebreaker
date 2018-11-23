module Codebreaker
  class Game
    attr_reader :attempts, :hints

    def initialize
      @secret_code = random
      @exit = false
    end

    def difficulty
      exit = false
      puts "Please enter level
            easy - 15 attempts. 2 hints
            medium - 10 attempts. 1 hint
            hell - 5 attempts. 1 hint"
      while exit != true
        case code = gets.chomp
        when 'easy'
          @total_attempts = @attempts = 15
          @total_hints = @hints = 2
          exit = true
        when 'medium'
          @total_attempts = @attempts = 10
          @total_hints = @hints = 1
          exit = true
        when 'hell'
          @total_attempts = @attempts = 5
          @total_hints = @hints = 1
          exit = true
        else
          puts 'You should enter: easy, medium, hell'
        end
      end
      @level = code
    end

    def random
      (1..4).map { rand(1..6) }
    end

    def guess(code)
      @code = code.split('').map(&:to_i)
      @attempts -= 1
      win
      mark
      no_attempts
    end

    def exit_with_status(message)
      @exit = true
      @status = message
    end

    def win
      return exit_with_status('Congratulations, you win!') if @code == @secret_code
    end

    def no_attempts
      return exit_with_status('Game over! You have no more attempts') if @attempts == 1
    end

    def hint
      return "You don't have any hints." if @hints.zero?

      @hints -= 1
      @secret_code.sample
    end

    def mark
      array_code = Array.new(@code)
      array_secret_code = Array.new(@secret_code)
      answer = []
      array_code.zip(array_secret_code).each_with_index do |(code, secret_code), i|
        next if code != secret_code

        array_secret_code[i], array_code[i] = nil
        answer << '+'
      end
      array_code.compact!
      array_secret_code.compact!
      array_code.map do |code|
        index = code && array_secret_code.index(code)
        next unless index

        array_secret_code[index] = nil
        answer << '-'
      end
      answer.join if @exit == false
    end

    def exit?
      @exit
    end

    def statistik
      "Status: #{@status}, level: #{@level}, secret code: #{@secret_code}, attempts total: #{@total_attempts},
      attempts used: #{@total_attempts - @attempts}, hints total:#{@total_hints}, hints used: #{@total_hints - @hints}"
    end
  end
end
