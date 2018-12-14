module Validation
  include Errors
  START_LENGTH =3.freeze
  FINISH_LENGTH =20.freeze

  def check_for_class(obj, klass)
    raise WrongClassError(obj, klass) unless obj.is_a? klass
  end

  def check_for_length(string)
    raise LengthError unless string.length.between?(START_LENGTH, FINISH_LENGTH)
  end
end
