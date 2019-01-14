module Codebreaker
  class Mark
    class << self
      def call(input_code, secret_code)
        @array_code = input_code.dup
        @array_secret_code = secret_code.dup
        mark_plus
        mark_minus
      end

      private

      def mark_plus
        @answer = @array_code.map.with_index do |guess_number, i|
          next if guess_number != @array_secret_code[i]

          @array_secret_code[i], @array_code[i] = nil
          '+'
        end
        @array_code.compact!
        @array_secret_code.compact!
      end

      def mark_minus
        @array_code.each do |code_number|
          index = @array_secret_code.index(code_number)
          next unless index

          @array_secret_code.delete_at(index)
          @answer << '-'
        end
        @answer.join
      end
    end
  end
end
