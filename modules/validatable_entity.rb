class ValidatableEntity
  include Validation

  def initialize
    @errors = []
  end

  def validate
    raise NotImplementedError
  end

  def valid?
    validate
    @errors.empty?
  end
end
