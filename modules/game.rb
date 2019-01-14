module Codebreaker
  class Game
    attr_reader :secret_code, :game_status, :hints, :attempts, :difficult, :array_input_code, :hint_array

    STATUS = { win: :win, no_attempts: :no_attempts, game: :game }.freeze
    RANGE_FOR_SECRET_CODE = (1..6).freeze
    SIGNS_FOR_SECRET_CODE = (1..4).freeze

    DIFFICULTIES = {
      easy: { hints: 2, attempts: 15, level: 'easy' },
      medium: { hints: 1, attempts: 10, level: 'medium' },
      hell: { hints: 1, attempts: 5, level: 'hell' }
    }.freeze

    def initialize
      @secret_code = random
      @game_status = STATUS[:game]
    end

    def difficulty(level)
      @difficult = DIFFICULTIES[level.to_sym]
      @attempts = difficult[:attempts]
      @hints = difficult[:hints]
    end

    def game_process(input)
      @array_input_code = input.split('').map(&:to_i)
      @attempts -= 1
      check_game_status
      mark
    end

    def receive_hint
      return if hints.zero?

      @hints -= 1
      @hint_array ||= secret_code.shuffle
      hint_array.pop
    end

    private

    def random
      SIGNS_FOR_SECRET_CODE.map { rand(RANGE_FOR_SECRET_CODE) }
    end

    def check_game_status
      return @game_status = STATUS[:win] if array_input_code == secret_code
      return @game_status = STATUS[:no_attempts] if attempts.zero?
    end

    def mark
      Codebreaker::Mark.call(array_input_code, secret_code)
    end
  end
end
