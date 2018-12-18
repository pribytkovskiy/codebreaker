require 'spec_helper'

RSpec.describe ValidatableEntity do
  subject(:validatable_entity) { described_class.new }

  let(:some_error) { 'Invalid input' }

  describe '.new' do
    it { expect(validatable_entity.instance_variable_get(:@errors)).to eq([]) }
  end

  describe 'when #validate raise' do
    it { expect { validatable_entity.validate }.to raise_error(NotImplementedError) }
  end
end
