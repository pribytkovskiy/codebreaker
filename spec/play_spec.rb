require 'spec_helper'
require './play.rb'
require './modules/codebreaker.rb'

RSpec.describe Play do
  let(:subject) { described_class.new }

  context '#introduction' do
    before(:each) do
      #allow(subject.instance_variable_get(:@game)).to receive(:exit?).and_return(true)
      allow(subject.game).to receive(:exit?).and_return(true)
    end

    it 'puts Welcome' do
      allow(subject).to receive(:gets).and_return('exit')
      expect { subject.introduction }.to output(/Welcome! Enter comand 'start', 'rules', 'stats', 'exit'./).to_stdout
    end

    xit 'unexpected command' do
      allow(subject).to receive(:gets).and_return('srartttt')
      expect { subject.introduction }.to output(/You have passed unexpected command. Please choose one from listed commands./).to_stdout
    end

    xit 'gets start' do
      allow(subject).to receive(:gets).and_return('start')
      expect { subject.introduction }.to output(/Please enter level/).to_stdout
    end    
  end

  context '#play_again' do
    before do
      allow(subject).to receive(:play_game)
      allow(subject).to receive(:gets).and_return('y')
    end

    it 'ask about play again' do
      expect { subject.send(:play_again) }.to output(/Would you like to play again?/).to_stdout
    end

    it 'create new game' do
      allow(subject).to receive(:puts)
      subject.send(:play_again)
    end

    it 'call #play_game method' do
      allow(subject).to receive(:puts)
      expect(subject).to receive(:play_game)
      subject.send(:play_again)
    end
  end

  context '#statisctics' do
    it 'look statisctics' do
      allow(File).to receive(:open)
      allow(subject).to receive(:gets).and_return('y')
      subject.send(:statisctics)
    end
  end

  context '#save' do
    before do
      allow(subject).to receive(:name).and_return('Petr')
      subject.game.difficulty(:hell, 5, 1)
    end

    it 'call #save method' do
      subject.send(:save)
    end

    it 'statistics should exist' do
     subject.send(:save)
      expect(File.exist?('./statisctics.txt')).to eq(true)
    end
  end
end
