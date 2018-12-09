require './auto_load.rb'

  RSpec.describe Validation do
    let(:name_not_string) { 1111 }
    let(:name_short_string) { 'Da' }

    context '#check_name_for_string' do
      it 'check_name_for_string' do
        expect { check_name_for_string(name_not_string) }.to raise_error(StandardError)
      end
    end

    context '#check_name_for_length' do
      it 'check_name_for_length' do
        expect { check_name_for_length(name_short_string) }.to raise_error(StandardError)
      end
    end
  end
