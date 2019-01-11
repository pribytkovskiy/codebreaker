module Codebreaker
  class Game
    attr_reader :secret_code, :game_status, :hints, :attempts, :difficult

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
      @hint_array.pop
    end

    private

    def random
      SIGNS_FOR_SECRET_CODE.map { rand(RANGE_FOR_SECRET_CODE) }
    end

    def check_game_status
      return @game_status = STATUS[:win] if @array_input_code == secret_code
      return @game_status = STATUS[:no_attempts] if attempts.zero?
    end

    def mark
      mark_plus
      mark_minus
    end

    def mark_plus
      @array_code = Array.new(@array_input_code)
      @array_secret_code = Array.new(secret_code)
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
      @answer.join if game_status == STATUS[:game]
    end
  end
end
