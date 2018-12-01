require 'spec_helper'
require './modules/codebreaker.rb'
require 'pry'

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
      it 'return true if @exit eq true' do
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
        it 'when win @exit eq true' do
          subject.instance_variable_set(:@secret_code, [1, 2, 3, 4])
          subject.guess('1234')
          expect(subject.instance_variable_get(:@exit)).to eq(true)
        end
      end

      context '#check_attempts' do
        it 'when game over @exit eq true' do
          subject.instance_variable_set(:@attempts, 1)
          subject.guess('1234')
          expect(subject.instance_variable_get(:@exit)).to eq(true)
        end
      end

      context 'secret_code' do
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

      context '#mark' do
        [[[1, 2, 2, 1], '2332', '--'], [[1, 2, 1, 1], '1121', '++--'],
         [[1, 2, 2, 2],  '2335', '-'],    [[1, 5, 5, 1], '1124', '+-'],
         [[5, 6, 5, 6],  '1221', ''],     [[4, 4, 1, 5], '5514', '+--'],
         [[1, 1, 1, 0],  '1111', '+++'], [[1, 2, 3, 4], '4321]', '----'],
         [[5, 5, 1, 4],  '4415', '+--'],  [[1, 2, 1, 1], '2112', '+--'],
         [[3, 1, 3, 1],  '1313', '----'], [[1, 2, 3, 4], '1255', '++'],
         [[3, 4, 1, 1],  '1124', '---'],  [[5, 5, 5, 1], '5133', '+-'],
         [[1, 4, 1, 5],  '4115', '++--'], [[2, 3, 1, 5], '4115', '++']].each do |item|
          it "Secret code is #{item[0]}, guess #{item[1]}, return #{item[2]}" do
            subject.instance_variable_set(:@secret_code, item[0])
            subject.instance_variable_set(:@exit, false)
            expect(subject.guess(item[1])).to eq(item[2])
          end
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
  end
end
