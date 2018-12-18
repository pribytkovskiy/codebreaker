require 'spec_helper'

module Codebreaker
  RSpec.describe Codebreaker::Game do
    subject(:game) { described_class.new }

    let(:difficult) { { level: 'hell', attempts: 5, hints: 1 } }
    let(:message) { 'message' }
    let(:hints) { 2 }
    let(:code) { [1, 2, 3, 4] }
    let(:code_string) { '1234' }
    let(:attempts) { 5 }

    context 'when #difficulty' do
      before { game.difficulty(difficult) }

      it 'check_total_attempts_params' do
        expect(game.instance_variable_get(:@total_attempts)).to eq(5)
      end

      it 'check_attempts_params' do
        expect(game.instance_variable_get(:@attempts)).to eq(5)
      end

      it 'check_total_hints_params' do
        expect(game.instance_variable_get(:@total_hints)).to eq(1)
      end

      it 'check_hints_params' do
        expect(game.instance_variable_get(:@hints)).to eq(1)
      end
    end

    context 'when #end_game?' do
      it 'return true if @end_game eq true' do
        game.instance_variable_set(:@end_game, true)
        expect(game.end_game?).to eq(true)
      end
    end

    context 'when #choice statistics' do
      it 'statistics string include status difficulty code' do
        game.instance_variable_set(:@total_attempts, attempts)
        game.instance_variable_set(:@attempts, attempts)
        game.instance_variable_set(:@total_hints, hints)
        game.instance_variable_set(:@hints, hints)
        game.instance_variable_set(:@status, 'Win')
        game.instance_variable_set(:@level, 'hell')
        game.instance_variable_set(:@secret_code, code_string)
        expect(game.statistics).to include('Win', 'hell', code_string)
      end

      it 'return statistics is a String' do
        game.difficulty(difficult)
        expect(game.statistics).to be_is_a(String)
      end
    end

    context 'when #guess' do
      before do
        game.difficulty(difficult)
      end

      it 'reduce attempts number by 1' do
        expect { game.guess(code_string) }.to change { game.instance_variable_get(:@attempts) }.by(-1)
      end

      it '@code Array' do
        game.guess(code_string)
        expect(game.instance_variable_get(:@code)).to eq(code)
      end

      context 'when #check_win' do
        it 'when win @end_game eq true' do
          game.instance_variable_set(:@secret_code, code)
          game.guess(code_string)
          expect(game.instance_variable_get(:@end_game)).to eq(true)
        end
      end

      context 'when #check_attempts' do
        it 'when game over @end_game eq true' do
          game.instance_variable_set(:@attempts, 1)
          game.guess(code_string)
          expect(game.instance_variable_get(:@end_game)).to eq(true)
        end
      end

      context 'when #secret_code' do
        it 'saves secret code' do
          expect(game.instance_variable_get(:@secret_code)).not_to be_empty
        end

        it 'saves 4 numbers secret code' do
          expect(game.instance_variable_get(:@secret_code).size).to eq(4)
        end

        it 'saves secret code with numbers from 1 to 6' do
          expect(game.instance_variable_get(:@secret_code).join).to match(/\A[1-6]{4}\Z/)
        end
      end

      context 'when #mark' do
        [[[1, 2, 2, 1], '2332', '--'], [[1, 2, 1, 1], '1121', '++--'],
         [[1, 2, 2, 2],  '2335', '-'],    [[1, 5, 5, 1], '1124', '+-'],
         [[5, 6, 5, 6],  '1221', ''],     [[4, 4, 1, 5], '5514', '+--'],
         [[1, 1, 1, 0],  '1111', '+++'], [[1, 2, 3, 4], '4321]', '----'],
         [[5, 5, 1, 4],  '4415', '+--'],  [[1, 2, 1, 1], '2112', '+--'],
         [[3, 1, 3, 1],  '1313', '----'], [[1, 2, 3, 4], '1255', '++'],
         [[3, 4, 1, 1],  '1124', '---'],  [[5, 5, 5, 1], '5133', '+-'],
         [[1, 4, 1, 5],  '4115', '++--'], [[2, 3, 1, 5], '4115', '++']].each do |item|
          it "Secret code is #{item[0]}, guess #{item[1]}, return #{item[2]}" do
            game.instance_variable_set(:@secret_code, item[0])
            game.instance_variable_set(:@end_game, false)
            expect(game.guess(item[1])).to eq(item[2])
          end
        end
      end
    end

    context 'when #hint' do
      it 'reduce hint number by 1' do
        game.instance_variable_set(:@hints, hints)
        expect { game.hint }.to change { game.instance_variable_get(:@hints) }.by(-1)
      end

      it "You don't have any hints." do
        game.instance_variable_set(:@hints, 0)
        expect(game.hint).to eq(I18n.t(:no_hint))
      end

      it 'return one number of secret code' do
        game.instance_variable_set(:@hints, hints)
        expect(game.instance_variable_get(:@secret_code)).to include(game.hint)
      end
    end

    context 'when #exit_with_status' do
      before { game.send(:exit_with_status, message) }

      it '@exit eq true.' do
        expect(game.instance_variable_get(:@end_game)).to eq(true)
      end

      it '@status eq message.' do
        expect(game.instance_variable_get(:@status)).to eq(message)
      end
    end
  end
end
