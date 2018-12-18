module Codebreaker
  class Game
    attr_reader :secret_code, :end_game

    RANGE_FOR_SECRET_CODE = (1..6).freeze
    SIGNS_FOR_SECRET_CODE = (1..4).freeze

    def initialize
      @secret_code = random
      @end_game = false
    end

    def difficulty(difficulty)
      @total_attempts = @attempts = difficulty[:attempts]
      @total_hints = @hints = difficulty[:hints]
      @level = difficulty[:level]
    end

    def end_game?
      @end_game
    end

    def statistics
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
      SIGNS_FOR_SECRET_CODE.map { rand(RANGE_FOR_SECRET_CODE) }
    end

    def exit_with_status(message)
      @end_game = true
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
      @answer.join if @end_game == false
    end
  end
end
