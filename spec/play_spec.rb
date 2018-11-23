require './play.rb'
require 'simplecov'
SimpleCov.start

RSpec.describe Play do
  subject(:play) { Play.new }

  context '#play_again' do
    before do
      allow(play).to receive(:play_game)
      allow(play).to receive(:gets).and_return('y')
    end

    it 'ask about play again' do
      expect { play.send(:play_again) }.to output(/Would you like to play again?/).to_stdout
    end

    it 'create new game' do
      allow(play).to receive(:puts)
      play.send(:play_again)
    end

    it 'call #play_game method' do
      allow(play).to receive(:puts)
      expect(play).to receive(:play_game)
      play.send(:play_again)
    end
  end

  context '#statisctics' do
    it 'look statisctics' do
      allow(File).to receive(:open)
      allow(play).to receive(:gets).and_return('y')
      expect { play.send(:statisctics) }.to output("Would you like look statisctics? (y,n)\n").to_stdout
    end
  end

  context '#save' do
    before do
      allow(play).to receive(:gets).and_return('y')
    end

    it 'ask about save statistics' do
      expect { play.send(:save) }.to output(/Would you like to save game result?/).to_stdout
    end

    it 'call #save method' do
      allow(play).to receive(:puts)
      play.send(:save)
    end

    it 'statistics should exist' do
      allow(play).to receive(:puts)
      play.send(:save)
      expect(File.exist?('./statisctics.txt')).to eq(true)
    end
  end
end