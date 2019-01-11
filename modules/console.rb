module Codebreaker
  class Console
    COMMANDS = { start: 'start', exit: 'exit', stats: 'stats', rules: 'rules', hint: 'hint', yes: 'y', no: 'n' }.freeze
    REG_EXP_FOR_CODE = /\A[1-6]{4}\Z/.freeze

    def initialize
      super()
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
        when COMMANDS[:start] then return start_game
        when COMMANDS[:exit] then return exit_message
        when COMMANDS[:stats] then open_statistics
        when COMMANDS[:rules] then open_rules
        else
          puts I18n.t(:unexpected_command)
        end
      end
    end

    def start_game
      receive_difficulty
      receive_name
      check_game_status
      save_statistics
      play_again
    end

    def receive_difficulty
      puts I18n.t(:level)
      loop do
        input_as_key = gets.chomp.to_sym
        if Codebreaker::Game::DIFFICULTIES.key?(input_as_key)
          return @game.difficulty(Codebreaker::Game::DIFFICULTIES[input_as_key][:level])
        end

        puts I18n.t(:unexpected_level)
      end
    end

    def receive_name
      puts I18n.t(:name)
      @name = gets.chomp
      p I18n.t(:wrong_class, obj: @name, klass: String) unless Codebreaker::Validation.check_for_class?(@name, String)
      puts I18n.t(:length_error) unless Codebreaker::Validation.check_for_length?(@name)
    end

    def check_game_status
      puts I18n.t(:enter_code)
      recive_code_or_hint until @game.game_status != Codebreaker::Game::STATUS[:game]
    end

    def recive_code_or_hint
      case code = gets.chomp
      when COMMANDS[:hint] then puts recive_hint
      when REG_EXP_FOR_CODE then puts @game.game_process(code)
      else
        puts I18n.t(:unexpected_code)
      end
    end

    def recive_hint
      return @game.receive_hint unless @game.hints.zero?

      puts I18n.t(:no_hint)
    end

    def play_again
      puts I18n.t(:play_again)
      return unless gets.chomp == COMMANDS[:yes]

      @game = Game.new
      start_game
    end

    def exit_message
      puts I18n.t(:goodbye)
    end

    def open_statistics
      return puts I18n.t(:no_file) if Codebreaker::Storage.open_statistics == Codebreaker::Storage::STATUS[:no_file]

      puts Codebreaker::Storage.open_statistics
    end

    def save_statistics
      Codebreaker::Storage.save_statistics(@name, @game)
    end

    def open_rules
      puts Codebreaker::Storage.open_rules
    end
  end
end
