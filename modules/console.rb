require './auto_load.rb'

module Codebreaker
  class Console
    include Validation

    HELL = { level: 'hell', attempts: 5, hints: 1 }.freeze
    MEDIUM = { level: 'medium', attempts: 10, hints: 1 }.freeze
    EASY = { level: 'easy', attempts: 15, hints: 2 }.freeze

    attr_reader :game

    def initialize
      @game = Game.new
    end

    def start
      puts I18n.t(:welcome)
      introduction
    end

    private

    def introduction
      loop do
        case gets.chomp
        when I18n.t(:start_command)
          play_game
          break
        when I18n.t(:exit_command)
          exit_message
          break
        when I18n.t(:stats_command)
          Storage.statisctics
        when I18n.t(:rules_command)
          Storage.open_rules
        else
          puts I18n.t(:unexpected_command)
        end
      end
    end

    def difficulty
      puts I18n.t(:level)
      loop do
        case gets.chomp
        when I18n.t(:easy_level)
          @game.difficulty(EASY)
          break
        when I18n.t(:medium_level)
          @game.difficulty(MEDIUM)
          break
        when I18n.t(:hell_level)
          @game.difficulty(HELL)
          break
        else
          puts I18n.t(:unexpected_level)
        end
      end
    end

    def play_game
      difficulty
      name
      game_code
      Storage.save(@name, @game)
      play_again
    end

    def game_code
      puts I18n.t(:enter_code)
      while @game.exit? != true
        case code = gets.chomp
        when I18n.t(:hint)
          puts @game.hint
        when /\A[1-6]{4}\Z/
          puts @game.guess(code)
        else
          puts I18n.t(:unexpected_code)
        end
      end
    end

    def name
      puts I18n.t(:name)
      @name = gets.chomp
      check_name_for_string(@name)
      check_name_for_length(@name)
    end

    def play_again
      puts I18n.t(:play_again)
      exit unless gets.chomp == 'y'
      @game = Game.new
      play_game
    end

    def exit_message
      puts I18n.t(:goodbye)
    end
  end
end
