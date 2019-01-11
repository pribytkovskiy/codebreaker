require 'spec_helper'

module Codebreaker
  RSpec.describe Codebreaker::Console do
    subject(:console) { described_class.new }

    FAKE_PATH_STATS = 'spec/fixtures/statistics.txt'.freeze

    let(:no) { Codebreaker::Console::COMMANDS[:no] }
    let(:code) { Codebreaker::Game::SIGNS_FOR_SECRET_CODE.map { FFaker::Random.rand(Codebreaker::Game::RANGE_FOR_SECRET_CODE) }.join }
    let(:name) { FFaker::Name::FIRST_NAMES.first }
    let(:path_stats) { Codebreaker::Storage::PATH_STATS }
    let(:difficult) { Codebreaker::Game::DIFFICULTIES[:hell] }
    let(:status) { Codebreaker::Game::STATUS[:win] }
    let(:attempts) { FFaker::Random.rand(5..15) }
    let(:hints) { FFaker::Random.rand(1..2) }
    let(:game) { instance_double('Game', game_status: status, difficult: difficult, secret_code: code, attempts: attempts, hints: hints) }


    context 'when #start' do
      it 'puts welcome message' do
        allow(console).to receive(:gets)
        allow(console).to receive(:introduction)
        expect { console.start }.to output(/#{I18n.t(:welcome)}/).to_stdout
      end
    end

    context 'when #play_again' do
      let(:yes) { Codebreaker::Console::COMMANDS[:yes] }

      it 'play_again yes' do
        allow(console).to receive_message_chain(:gets, :chomp) { yes }
        allow(console).to receive(:start_game)
        expect { console.send(:play_again) }.to output("#{I18n.t(:play_again)}\n").to_stdout
      end
    end

    context 'when #introduction hint' do
      let(:hint) { Codebreaker::Console::COMMANDS[:hint] }

      it 'hint' do
        commands = [hint, code, code, code, code, code, no]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        allow(console).to receive(:loop).and_yield
        console.instance_variable_get(:@game).instance_variable_set(:@hints, 1)
        console.instance_variable_get(:@game).instance_variable_set(:@attempts, 1)
        expect { console.send(:check_game_status) }.to output(/#{I18n.t(:enter_code)}/).to_stdout
      end
    end

    context 'when #introduction' do
      let(:start) { Codebreaker::Console::COMMANDS[:start] }
      let(:exit) { Codebreaker::Console::COMMANDS[:exit] }
      let(:statisctics) { Codebreaker::Console::COMMANDS[:stats] }
      let(:open_rules) { Codebreaker::Console::COMMANDS[:rules] }
      let(:level) { Codebreaker::Game::DIFFICULTIES[:hell][:level] }
      let(:unexpected_command) { FFaker::Lorem.phrase }

      it 'exit_message' do
        allow(console).to receive_message_chain(:gets, :chomp) { exit }
        expect { console.start }.to output(/#{I18n.t(:goodbye)}/).to_stdout
      end

      it 'statisctics no file' do
        commands = [statisctics, exit]
        File.delete(FAKE_PATH_STATS) if File.file?(FAKE_PATH_STATS)
        stub_const('Codebreaker::Storage::PATH_STATS', FAKE_PATH_STATS)
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/#{I18n.t(:no_file)}/).to_stdout
      end

      it 'open_rules' do
        commands = [open_rules, exit]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/rules/).to_stdout
      end

      it 'bad command' do
        commands = [unexpected_command, exit]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/#{I18n.t(:unexpected_command)}/).to_stdout
      end

      it 'start_game' do
        commands = [start, level, name, code, code, code, code, code, no]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/again/).to_stdout
      end

      it 'start_game unexpected_code' do
        commands = [start, level, name, code, code, code, code, unexpected_command, code, no]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/#{I18n.t(:unexpected_code)}/).to_stdout
      end

      context 'when #statisctics' do
        before do
          commands = [start, level, name, code, code, code, code, code, no]
          allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        end

        it 'statisctics' do
          commands = [statisctics, exit]
          allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
          expect { console.start }.to output(/#{name}/).to_stdout
        end
      end
    end

    context 'when #save_statistics' do
      before do
        console.instance_variable_set(:@name, name)
        console.instance_variable_set(:@game, game)
        stub_const('Codebreaker::Storage::PATH_STATS', FAKE_PATH_STATS)
      end

      after do
        File.delete(FAKE_PATH_STATS) if File.exist?(FAKE_PATH_STATS)
      end

      it 'call #save method' do
        allow(console).to receive(:puts)
        console.send(:save_statistics)
      end

      it 'statistics should exist' do
        allow(console).to receive(:puts)
        console.send(:save_statistics)
        expect(File.exist?(FAKE_PATH_STATS)).to eq(true)
      end
    end
  end
end
