module Codebreaker
  class Game
    attr_reader :secret_code, :end_game, :hints

    RANGE_FOR_SECRET_CODE = (1..6).freeze
    SIGNS_FOR_SECRET_CODE = (1..4).freeze

    DIFFICULTIES = {
      easy: { hints: 2, attempts: 15, level: 'easy' },
      medium: { hints: 1, attempts: 10, level: 'medium' },
      hell: { hints: 1, attempts: 5, level: 'hell' }
    }.freeze

    def initialize
      @secret_code = random
      @end_game = false
    end

    def difficulty(level)
      @difficult = DIFFICULTIES[level.to_sym]
      @attempts = @difficult[:attempts]
      @hints = @difficult[:hints]
    end

    def statistics
      I18n.t(
        :statistics, status: @status, level: @difficult[:level],
        secret_code: @secret_code, total_attempts: @difficult[:attempts],
        attempts_used: attempts_used, total_hints: @difficult[:hints],
        hints_used: hints_used
      )
    end

    def attempts_used
      @difficult[:attempts] - @attempts
    end

    def hints_used
      @difficult[:hints] - hints
    end

    def guess(code)
      @code = code.split('').map(&:to_i)
      @attempts -= 1
      check_win
      check_attempts
      mark
    end

    def hint
      return if hints.zero?

      @hints -= 1
      @hint_array ||= secret_code.shuffle
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
      @answer.join if end_game == false
    end
  end
end
