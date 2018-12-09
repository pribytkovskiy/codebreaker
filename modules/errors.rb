module Errors
  class NameNoStringError < StandardError
    def initialize
      super('Name no string!')
    end
  end

  class NameLengthError < StandardError
    def initialize
      super('Name length between 3 - 20 chars')
    end
  end
end
