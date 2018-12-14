module Errors
  class WrongClassError < StandardError
    def initialize
      super("Wrong class! #{obj} class not #{klass}")
    end
  end

  class LengthError < StandardError
    LENGTH_ERROR = 'Length between 3 - 20 chars'.freeze
    def initialize
      super(LENGTH_ERROR)
    end
  end
end
