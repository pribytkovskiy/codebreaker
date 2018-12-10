require 'spec_helper'
require './auto_load.rb'
require './modules/console.rb'

module Codebreaker
  RSpec.describe Codebreaker::Console do
    subject { described_class.new }
    let(:exit) { 'exit' }
    let(:start) { 'start' }
    let(:bad_command) { 'startttt' }
    let(:level) { 'hell' }
    let(:name) { 'Dima' }
    let(:hint) { 'hint' }
    let(:bad_code) { '12345' }
    let(:code) { '1234' }
    let(:stats) { 'stats' }
    let(:rules) { 'rules' }
    let(:easy) { 'easy' }
    let(:medium) { 'medium' }

    context '#start' do
      it 'puts welcome and goodbye' do
        allow(subject).to receive(:gets).and_return('exit')
        expect { subject.start }.to output(/Welcome! Enter comand 'start', 'rules', 'stats', 'exit'./).to_stdout
        expect { subject.start }.to output(/Goodbye message!/).to_stdout
      end

      context '#introduction' do
        it 'unexpected command' do
          allow(subject).to receive(:gets) do
            @counter ||= 0
            response = if @counter > 1
                         exit
                       else
                         bad_command
                       end
            @counter += 1
            response
          end
          expect { subject.start }.to output(/You have passed unexpected command. Please choose one from listed commands./).to_stdout
        end

        it 'play_game' do
          allow(subject).to receive(:gets) do
            @counter ||= 0
            response = if @counter == 0
                         start
                       elsif @counter == 1
                         level
                       elsif @counter == 2
                         name
                       elsif @counter == 3
                         hint
                       elsif @counter == 4
                         bad_code
                       elsif @counter > 10
                         'y'
                       elsif @counter > 4
                         code 
                       end
            @counter += 1
            response
          end
          expect { subject.start }.to output(/Please enter level easy - 15 attempts. 2 hints medium - 10 attempts. 1 hint hell - 5 attempts. 1 hint./).to_stdout
          expect { subject.start }.to output(/You should make a guess of 4 numbers from 1 to 6./).to_stdout
          expect { subject.start }.to output(/Your name./).to_stdout
          expect { subject.start }.to output(/Codebreaker! Make a guess of 4 numbers from 1 to 6. Enter code or comand 'hint' to hint./).to_stdout
        end
      end
    end
        
    it 'stats' do
      allow(subject).to receive(:gets) do
        @counter ||= 0
        response = if @counter > 1
                     exit
                   else
                     stats
                   end
        @counter += 1
        response
      end
      expect { subject.start }.to output(/Dima/).to_stdout
    end

    it 'rules' do
      allow(subject).to receive(:gets) do
        @counter ||= 0
        response = if @counter > 1
                     exit
                   else
                     rules
                   end
        @counter += 1
        response
      end
      expect { subject.start }.to output(/Game Rules/).to_stdout
    end

    it 'difficulty easy' do
      allow(subject).to receive(:gets).and_return(easy)
      expect { subject.send(:difficulty) }.to output(/Please enter level easy - 15 attempts. 2 hints medium - 10 attempts. 1 hint hell - 5 attempts. 1 hint/).to_stdout
    end

    it 'difficulty medium' do
      allow(subject).to receive(:gets).and_return(medium)
      expect { subject.send(:difficulty) }.to output(/Please enter level easy - 15 attempts. 2 hints medium - 10 attempts. 1 hint hell - 5 attempts. 1 hint/).to_stdout
    end

    it 'bad difficulty' do
      allow(subject).to receive(:gets) do
        @counter ||= 0
        response = if @counter > 1
                     medium
                   else
                     bad_command
                   end
        @counter += 1
        response
      end
      expect { subject.send(:difficulty) }.to output(/You should enter: easy, medium, hell/).to_stdout
    end

    context '#name' do
      it 'ask name' do
        allow(subject).to receive(:gets).and_return(name)
        expect { subject.send(:name) }.to output(/Your name./).to_stdout
      end

      it 'get bad name' do
        allow(subject).to receive(:gets).and_return('y')
        expect { csubject.send(:name) }.to raise_error(StandardError)
      end

      it 'get good name' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets).and_return(name)
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
  end
end
