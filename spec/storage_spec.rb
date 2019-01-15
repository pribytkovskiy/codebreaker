require 'spec_helper'

RSpec.describe Codebreaker::Validation do
  subject(:current_subject) { Codebreaker::Storage }

  FAKE_PATH_STATS = 'spec/fixtures/statistics.txt'.freeze

  context 'open save statistics' do
    let(:name) { FFaker::Name::FIRST_NAMES.first }
    let(:difficult) { { level: 'hell', attempts: 5, hints: 1 } }
    let(:status) { :win }
    let(:attempts) { FFaker::Random.rand(5..15) }
    let(:hints) { FFaker::Random.rand(1..2) }
    let(:code) { Codebreaker::Game::SIGNS_FOR_SECRET_CODE.map { FFaker::Random.rand(Codebreaker::Game::RANGE_FOR_SECRET_CODE) }.join }
    let(:game) { instance_double('Game', game_status: status, difficult: difficult, secret_code: code, attempts: attempts, hints: hints) }
    let(:no_file) { :no_file }
    
    before do
      stub_const('Codebreaker::Storage::PATH_STATS', FAKE_PATH_STATS)
    end

    after do
      File.delete(FAKE_PATH_STATS) if File.exist?(FAKE_PATH_STATS)
    end

    it 'not file statistics when #open_statistics' do
      current_subject.open_statistics
      statistics = current_subject.open_statistics
      expect(statistics).to eq(no_file)
    end

    it 'when #open_statistics' do
      current_subject.save_statistics(name, game)
      statistics = current_subject.open_statistics
      expect(statistics).to include(name)
    end

    it 'write statistics in file when #save_statistics(name, game)' do
      current_subject.save_statistics(name, game)
      expect(File.exist?(FAKE_PATH_STATS)).to be true
      statistics = File.open(FAKE_PATH_STATS, 'r') { |f| f.read }
      expect(statistics).to include(name)
    end
  end

  context 'when #open_rules' do
    let(:rules) { 'Game Rules' }

    it 'open rules' do
      rules = current_subject.open_rules
      expect(File.exist?(Codebreaker::Storage::PATH_RULES)).to be true
      expect(rules).to include(rules)
    end
  end
end
