module Codebreaker
  class Mark
    class << self
      def mark
        mark_plus
        mark_minus
      end

      private

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
        @answer.join if game_status == :game
      end
    end
  end
end
