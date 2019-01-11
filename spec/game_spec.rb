require 'spec_helper'

module Codebreaker
  RSpec.describe Codebreaker::Game do
    subject(:game) { described_class.new }

    let(:difficult) { Codebreaker::Game::DIFFICULTIES[:hell] }

    context 'when #difficulty' do
      before { game.difficulty(difficult[:level]) }

      it 'check_total_attempts_params' do
        expect(game.instance_variable_get(:@difficult)).to eq(difficult)
      end

      it 'check_attempts_params' do
        expect(game.instance_variable_get(:@attempts)).to eq(5)
      end

      it 'check_hints_params' do
        expect(game.instance_variable_get(:@hints)).to eq(1)
      end
    end

    context 'when #game_process' do
      let(:code) { Codebreaker::Game::SIGNS_FOR_SECRET_CODE.map { FFaker::Random.rand(Codebreaker::Game::RANGE_FOR_SECRET_CODE) } }
      let(:code_string) { code.join }

      before do
        game.difficulty(difficult[:level])
      end

      it 'reduce attempts number by 1' do
        expect { game.game_process(code_string) }.to change { game.instance_variable_get(:@attempts) }.by(-1)
      end

      it '@code Array' do
        game.game_process(code_string)
        expect(game.instance_variable_get(:@array_input_code)).to eq(code)
      end

      context 'when #check_game_status win' do
        let(:game_status_win) { Codebreaker::Game::STATUS[:win] }
        let(:game_status_no_attempts) { Codebreaker::Game::STATUS[:no_attempts] }

        it 'when win @game_status eq win' do
          game.instance_variable_set(:@secret_code, code)
          game.game_process(code_string)
          expect(game.instance_variable_get(:@game_status)).to eq(game_status_win)
        end

        it 'when game over @game_statueeq no_attempts' do
          game.instance_variable_set(:@attempts, 1)
          game.game_process(code_string)
          expect(game.instance_variable_get(:@game_status)).to eq(game_status_no_attempts)
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
            game.instance_variable_set(:@game_status, :game)
            expect(game.game_process(item[1])).to eq(item[2])
          end
        end
      end
    end

    context 'when #hint' do
      let(:hints) { FFaker::Random.rand(1..2) }

      it 'reduce hint number by 1' do
        game.instance_variable_set(:@hints, hints)
        expect { game.receive_hint }.to change { game.instance_variable_get(:@hints) }.by(-1)
      end

      it "You don't have any hints." do
        game.instance_variable_set(:@hints, 0)
        expect(game.receive_hint).to eq(nil)
      end

      it 'return one number of secret code' do
        game.instance_variable_set(:@hints, hints)
        expect(game.instance_variable_get(:@secret_code)).to include(game.receive_hint)
      end
    end
  end
end
