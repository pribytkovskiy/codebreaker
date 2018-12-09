module Validation
  include Errors

  def check_name_for_string(name)
    raise NameNoStringError unless name.is_a?(String)
  end

  def check_name_for_length(name)
    raise NameLengthError unless name.length.between?(3, 20)
  end
end
