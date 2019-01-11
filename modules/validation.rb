module Codebreaker
  class Validation
    START_LENGTH = 3
    FINISH_LENGTH = 20

    class << self
      def check_for_class?(obj, klass)
        obj.is_a? klass
      end

      def check_for_length?(string)
        string.length.between?(START_LENGTH, FINISH_LENGTH)
      end
    end
  end
end
