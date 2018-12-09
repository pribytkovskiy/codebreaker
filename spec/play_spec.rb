require 'spec_helper'
require './play.rb'
require './modules/codebreaker.rb'

RSpec.describe Console do
  let(:subject) { described_class.new }

  context '#introduction' do
    it 'puts Welcome' do
      allow(subject).to receive(:gets).and_return('exit')
      expect { subject.introduction }.to output(/Welcome! Enter comand 'start', 'rules', 'stats', 'exit'./).to_stdout
    end

    it 'gets Goodbye' do
      allow(subject).to receive(:gets).and_return('exit')
      expect { subject.introduction }.to output(/Goodbye message!/).to_stdout
    end

    it 'unexpected command' do
      allow(subject).to receive(:gets) do
        @counter ||= 0
        response = if @counter > 1
                     'exit'
                   else
                     'startttt'
                   end
        @counter += 1
        response
      end
      expect { subject.introduction }.to output(/You have passed unexpected command. Please choose one from listed commands./).to_stdout
    end
  end

  context '#play_game' do
    before do
      allow(subject).to receive(:difficulty)
      allow(subject).to receive(:name)
    end

    it 'ask code' do
      allow(subject).to receive(:gets).and_return('exit')
      expect { subject.send(:play_game) }.to output(/Codebreaker! Make a guess of 4 numbers from 1 to 6. Enter code or comand 'hint' to hint./).to_stdout
    end

    it 'unexpected command' do
      allow(subject).to receive(:gets) do
        @counter ||= 0
        response = if @counter > 1
                     'exit'
                   else
                     'startttt'
                   end
        @counter += 1
        response
      end
      expect { subject.send(:play_game) }.to output(/You should make a guess of 4 numbers from 1 to 6./).to_stdout
    end
  end

  context '#difficulty' do
    it 'ask difficulty' do
      allow(subject).to receive(:gets).and_return('hell')
      expect { subject.send(:difficulty) }.to output(/Please enter level/).to_stdout
    end

    it 'get easy difficulty' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('easy')
      expect(subject.send(:difficulty)).to eq(:easy)
    end

    it 'get medium difficulty' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('medium')
      expect(subject.send(:difficulty)).to eq(:medium)
    end

    it 'get hell difficulty' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('hell')
      expect(subject.send(:difficulty)).to eq(:hell)
    end
  end

  context '#name' do
    it 'ask name' do
      allow(subject).to receive(:gets).and_return('Petr')
      expect { subject.send(:name) }.to output(/Your name./).to_stdout
    end

    it 'get bad name' do
      allow(subject).to receive(:gets).and_return('y')
      expect { subject.send(:name) }.to output(/String, required, min length - 3 symbols, max length - 20 symbols./).to_stdout
    end

    it 'get good name' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:gets).and_return('Petr')
      expect(subject.send(:name)).to eq(nil)
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
      expect { subject.send(:play_again) }.to change { subject.instance_variable_get(:@game) }
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

    it 'statistics should exist' do
      subject.send(:save)
      expect(File.exist?('./db/statisctics.txt')).to eq(true)
    end
  end
end
