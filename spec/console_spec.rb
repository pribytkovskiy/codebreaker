require 'spec_helper'

module Codebreaker
  RSpec.describe Codebreaker::Console do
    subject(:console) { described_class.new }

    let(:start) { Codebreaker::Console::COMMANDS[:start] }
    let(:exit) { Codebreaker::Console::COMMANDS[:exit] }
    let(:statisctics) { Codebreaker::Console::COMMANDS[:stats] }
    let(:open_rules) { Codebreaker::Console::COMMANDS[:rules] }
    let(:hint) { Codebreaker::Console::COMMANDS[:hint] }
    let(:no) { Codebreaker::Console::COMMANDS[:no] }
    let(:yes) { Codebreaker::Console::COMMANDS[:yes] }
    let(:level) { Codebreaker::Game::DIFFICULTIES[:hell][:level] }
    let(:code) { Codebreaker::Game::SIGNS_FOR_SECRET_CODE.map { FFaker::Random.rand(Codebreaker::Game::RANGE_FOR_SECRET_CODE) }.join }
    let(:name) { FFaker::Name::FIRST_NAMES }
    let(:rules) { 'Game Rules' }
    let(:unexpected_command) { 'startttt' }
    let(:path_stats) { Codebreaker::Console::PATH_STATS }
    let(:game) { instance_double('Game', statistics: FFaker::Lorem.phrase) }

    context 'when #start' do
      it 'puts welcome message' do
        allow(console).to receive(:gets)
        allow(console).to receive(:introduction)
        expect { console.start }.to output(/#{I18n.t(:welcome)}/).to_stdout
      end
    end

    context 'when #play_again' do
      it 'play_again yes' do
        allow(console).to receive_message_chain(:gets, :chomp) { yes }
        allow(console).to receive(:play_game)
        expect { console.send(:play_again) }.to output("#{I18n.t(:play_again)}\n").to_stdout
      end
    end

    context 'when #introduction hint' do
      it 'hint' do
        commands = [hint, code, code, code, code, code, no]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        allow(console).to receive(:loop).and_yield
        console.instance_variable_get(:@game).instance_variable_set(:@hints, 1)
        console.instance_variable_get(:@game).instance_variable_set(:@attempts, 1)
        expect { console.send(:receive_game_code) }.to output(/#{I18n.t(:enter_code)}/).to_stdout
      end
    end

    context 'when #introduction' do
      it 'exit_message' do
        allow(console).to receive_message_chain(:gets, :chomp) { exit }
        expect { console.start }.to output(/#{I18n.t(:goodbye)}/).to_stdout
      end

      it 'statisctics no file' do
        commands = [statisctics, exit]
        File.delete(path_stats) if File.file?(path_stats)
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/#{I18n.t(:no_file)}/).to_stdout
      end

      it 'open_rules' do
        commands = [open_rules, exit]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/#{rules}/).to_stdout
      end

      it 'bad command' do
        commands = [unexpected_command, exit]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/#{I18n.t(:unexpected_command)}/).to_stdout
      end

      it 'play_game' do
        commands = [start, level, name, code, code, code, code, code, no]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/again/).to_stdout
      end

      it 'play_game unexpected_code' do
        commands = [start, level, name, code, code, code, code, unexpected_command, code, no]
        allow(console).to receive_message_chain(:gets, :chomp).and_return(*commands)
        expect { console.start }.to output(/#{I18n.t(:unexpected_code)}/).to_stdout
      end

      context 'when #statisctics' do
        let(:name) { FFaker::Name::FIRST_NAMES }

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

    context 'when #save_statisctics' do
      before do
        console.instance_variable_set(:@name, name)
        console.instance_variable_set(:@game, game)
      end

      it 'call #save method' do
        allow(console).to receive(:puts)
        console.send(:save_statistics)
      end

      it 'statistics should exist' do
        allow(console).to receive(:puts)
        console.send(:save_statistics)
        expect(File.exist?(path_stats)).to eq(true)
      end
    end
  end
end
