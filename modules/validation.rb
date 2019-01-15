module Codebreaker
  class Validation
    class << self
      def check_for_class?(obj, klass)
        obj.is_a? klass
      end

      def check_for_length?(string, start_length, finish_length)
        string.length.between?(start_length, finish_length)
      end
    end
  end
end
