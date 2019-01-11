module Codebreaker
  class Mark
    class << self
      def mark_plus(input_code, secret_code)
        array_code = Array.new(input_code)
        array_secret_code = Array.new(secret_code)
        @answer = []
        array_code.zip(array_secret_code).each_with_index do |(code, secret_code), i|
          next if code != secret_code

          array_secret_code[i], array_code[i] = nil
          @answer << '+'
        end
        mark_minus(array_code, array_secret_code)
      end

      private

      def mark_minus(array_code, array_secret_code)
        array_code.compact!
        array_secret_code.compact!
        array_code.map do |code|
          index = code && array_secret_code.index(code)
          next unless index

          array_secret_code[index] = nil
          @answer << '-'
        end
        @answer.join
      end
    end
  end
end
