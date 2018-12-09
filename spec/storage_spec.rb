require './auto_load.rb'

module Codebreaker
  RSpec.describe Codebreaker::Storage do
    subject(:subject) { described_class }
    let(:name) { 'Dima' }
    let(:game) { double('game', statistik: 'Win') }
    let(:path_rules) { './db/rules.txt' }
    let(:path_stats) { './db/statisctics.txt' }

    context '#save' do
      after do
        File.delete(path_stats.to_s) if File.exist?(path_stats.to_s)
      end
      it 'statistics should exist' do
        subject.save(name, game)
        expect(File.exist?(path_stats.to_s)).to eq(true)
      end
    end

    context '#statisctics' do
      before do
        subject.save(name, game)
      end

      it 'answer statisctics' do
        allow(File).to receive(:open)
        allow(subject).to receive(:gets).and_return('y')
        subject.send(:statisctics)
      end

      it 'look statisctics' do
        allow(subject).to receive(:gets).and_return('y')
        expect { subject.statisctics }.to output(/Dima/).to_stdout
      end

      it 'not statisctics file' do
        File.delete(path_stats.to_s) if File.exist?(path_stats.to_s)
        allow(subject).to receive(:gets).and_return('y')
        expect { subject.statisctics }.to output("#{I18n.t(:no_file)}\n").to_stdout
      end
    end

    context '#open_rules' do
      it 'look rules' do
        expect { subject.open_rules }.to output(/Game Rules/).to_stdout
      end
    end
  end
end
