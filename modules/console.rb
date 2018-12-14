module Codebreaker
  class Console
    include Validation

    DIFFICULTIES = { easy: { hints: 2, attempts: 15, level: 'easy' },
                 medium: { hints: 1, attempts: 10, level: 'medium' },
                 hell: { hints: 1, attempts: 5, level: 'hell' } }.freeze
    COMMANDS = { start: 'start', exit: 'exit', stats: 'stats', rusel: 'rules', hint: 'hint' }.freeze
    REG_EXP_FOR_CODE = /\A[1-6]{4}\Z/

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
        when COMMANDS[:start] then return play_game
        when COMMANDS[:exit] then return exit_message
        when COMMANDS[:stats] then Storage.statisctics
        when COMMANDS[:rules] then Storage.open_rules
        else
          puts I18n.t(:unexpected_command)
        end
      end
    end

    def get_difficulty
      puts I18n.t(:level)
      loop do
        input_as_key = gets.chomp.to_sym
        puts I18n.t(:unexpected_level) unless DIFFICULTIES.key?(input_as_key)
        return @game.difficulty(DIFFICULTIES[input_as_key.to_sym]) if DIFFICULTIES.key?(input_as_key)
      end
    end

    def play_game
      get_difficulty
      get_name
      get_game_code
      Storage.save(@name, @game)
      play_again
    end

    def get_game_code
      puts I18n.t(:enter_code)
      while !@game.end_game?
        case code = gets.chomp
        when COMMANDS[:hint] then puts @game.hint
        when REG_EXP_FOR_CODE then puts @game.guess(code)
        else
          puts I18n.t(:unexpected_code)
        end
      end
    end

    def get_name
      puts I18n.t(:name)
      @name = gets.chomp
      check_for_class(@name, String)
      check_for_length(@name)
    end

    def play_again
      puts I18n.t(:play_again)
      exit if gets.chomp != 'y'
      @game = Game.new
      play_game
    end

    def exit_message
      puts I18n.t(:goodbye)
    end
  end
end
