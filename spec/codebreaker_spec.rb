require 'spec_helper'
require './modules/codebreaker.rb'

module Codebreaker
  RSpec.describe Codebreaker::Game do
    subject(:subject) { described_class.new }

    context '#difficulty' do
      it 'check_params' do
        subject.difficulty(:hell, 5, 1)
        expect(subject.instance_variable_get(:@total_attempts)).to eq(5)
        expect(subject.instance_variable_get(:@attempts)).to eq(5)
        expect(subject.instance_variable_get(:@total_hints)).to eq(1)
        expect(subject.instance_variable_get(:@hints)).to eq(1)
      end
    end

    context '#exit?' do
      it 'return false if no attempts' do
        subject.instance_variable_set(:@exit, true)
        expect(subject.exit?).to eq(true)   
      end
    end

    context '#statistik' do
      it 'statistik string include status difficulty code' do
        subject.instance_variable_set(:@total_attempts, 5)
        subject.instance_variable_set(:@attempts, 5)
        subject.instance_variable_set(:@total_hints, 1)
        subject.instance_variable_set(:@hints, 1)
        subject.instance_variable_set(:@status, 'Win')
        subject.instance_variable_set(:@level, 'hell')
        subject.instance_variable_set(:@secret_code, 1111)
        expect(subject.statistik).to include('Win', 'hell', '1111')
      end

      it 'return statistik is a String' do
        subject.difficulty(:hell, 5, 1)
        expect(subject.statistik).to be_is_a(String)
      end
    end

    context '#guess' do
      before do
        subject.difficulty(:hell, 5, 1)
      end

      it 'reduce attempts number by 1' do
        expect { subject.guess('1234') }.to change { subject.instance_variable_get(:@attempts) }.by(-1)
      end

      it '@code Array' do
        subject.guess('1234')
        expect(subject.instance_variable_get(:@code)).to eq([1, 2, 3, 4])
      end

      context '#check_win' do
        it 'when win' do
          subject.instance_variable_set(:@secret_code, [1, 2, 3, 4])
          expect(subject.guess('1234')).to eq('Congratulations, you win!')
        end
      end
    end

    context '#hint' do
      it 'reduce hint number by 1' do
        subject.instance_variable_set(:@hints, 2)
        expect { subject.hint }.to change { subject.instance_variable_get(:@hints) }.by(-1)
      end

      it "You don't have any hints." do
        subject.instance_variable_set(:@hints, 0)
        expect(subject.hint).to eq("You don't have any hints.")
      end

      it 'return one number of secret code' do
        subject.instance_variable_set(:@hints, 1)
        expect(subject.instance_variable_get(:@secret_code)).to include(subject.hint)
      end
    end

    context '#start' do
      it 'saves secret code' do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(subject.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(subject.instance_variable_get(:@secret_code).join).to match(/\A[1-6]{4}\Z/)
      end
    end

    context '#exit_with_status' do
      before do
        subject.send(:exit_with_status, 'message')
      end

      it 'message' do
        expect(subject.instance_variable_get(:@status)).to eq('message')
      end

      it '@exit = true' do
        expect(subject.instance_variable_get(:@exit)).to eq(true)
      end
    end

    context '#check_win' do
      it 'when win' do
        subject.instance_variable_set(:@secret_code, [1, 2, 3, 4])
        subject.instance_variable_set(:@code, [1, 2, 3, 4])
        expect(subject.send(:check_win)).to eq('Congratulations, you win!')
      end
    end

    context '#check_attempts' do
      it 'when game over' do
        subject.instance_variable_set(:@attempts, 0)
        expect(subject.send(:check_attempts)).to eq('Game over! You have no more attempts')
      end
    end

    context '#game' do
      [[[1, 2, 2, 1], [2, 3, 3, 2], '--'], [[1, 2, 1, 1], [1, 1, 2, 1], '++--'],
       [[1, 2, 2, 2],  [2, 3, 3, 5], '-'],    [[1, 5, 5, 1], [1, 1, 2, 4], '+-'],
       [[5, 6, 5, 6],  [1, 2, 2, 1], ''],     [[4, 4, 1, 5], [5, 5, 1, 4], '+--'],
       [[1, 1, 1, 1],  [1, 1, 1, 1], '++++'], [[1, 2, 3, 4], [4, 3, 2, 1], '----'],
       [[5, 5, 1, 4],  [4, 4, 1, 5], '+--'],  [[1, 2, 1, 1], [2, 1, 1, 2], '+--'],
       [[3, 1, 3, 1],  [1, 3, 1, 3], '----'], [[1, 2, 3, 4], [1, 2, 5, 5], '++'],
       [[3, 4, 1, 1],  [1, 1, 2, 4], '---'],  [[5, 5, 5, 1], [5, 1, 3, 3], '+-'],
       [[1, 4, 1, 5],  [4, 1, 1, 5], '++--'], [[2, 3, 1, 5], [4, 1, 1, 5], '++']].each do |item|
        it "Secret code is #{item[0]}, guess #{item[1]}, return #{item[2]}" do
          subject.instance_variable_set(:@secret_code, item[0])
          subject.instance_variable_set(:@exit, false)
          subject.instance_variable_set(:@code, item[1])
          expect(subject.send(:mark)).to eq(item[2])
        end
      end
    end
  end
end
