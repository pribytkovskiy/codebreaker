require 'i18n'

module Codebreaker
  class Game
    def initialize
      @secret_code = random
      @exit = false
    end

    def difficulty(difficult)
      @total_attempts = @attempts = difficult[:attempts]
      @total_hints = @hints = difficult[:hints]
      @level = difficult[:level]
    end

    def exit?
      @exit
    end

    def statistik
      "Status: #{@status}, level: #{@level}, secret code: #{@secret_code}, attempts total: #{@total_attempts},
      attempts used: #{@total_attempts - @attempts}, hints total:#{@total_hints}, hints used: #{@total_hints - @hints}"
    end

    def guess(code)
      @code = code.split('').map(&:to_i)
      @attempts -= 1
      check_win
      check_attempts
      mark
    end

    def hint
      return I18n.t(:no_hint) if @hints.zero?

      @hints -= 1
      @hint_array ||= @secret_code.shuffle
      @hint_array.pop
    end

    private

    def random
      (1..4).map { rand(1..6) }
    end

    def exit_with_status(message)
      @exit = true
      @status = message
    end

    def check_win
      return exit_with_status(I18n.t(:win)) if @code == @secret_code
    end

    def check_attempts
      return exit_with_status(I18n.t(:no_attempts)) if @attempts.zero?
    end

    def mark
      mark_plus
      mark_minus
    end

    def mark_plus
      @array_code = Array.new(@code)
      @array_secret_code = Array.new(@secret_code)
      @answer = []
      @array_code.zip(@array_secret_code).each_with_index do |(code, secret_code), i|
        next if code != secret_code

        @array_secret_code[i], @array_code[i] = nil
        @answer << '+'
      end
    end

    def mark_minus
      @array_code.compact!
      @array_secret_code.compact!
      @array_code.map do |code|
        index = code && @array_secret_code.index(code)
        next unless index

        @array_secret_code[index] = nil
        @answer << '-'
      end
      @answer.join if @exit == false
    end
  end
end
