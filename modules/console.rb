module Codebreaker
  class Console < ValidatableEntity

    COMMANDS = { start: 'start', exit: 'exit', stats: 'stats', rules: 'rules', hint: 'hint', yes: 'y', no: 'n' }.freeze
    REG_EXP_FOR_CODE = /\A[1-6]{4}\Z/.freeze
    PATH_RULES = './db/rules.txt'.freeze
    PATH_STATS = './db/statistics.txt'.freeze

    attr_reader :name, :game, :errors

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
        when COMMANDS[:start] then return play_game
        when COMMANDS[:exit] then return exit_message
        when COMMANDS[:stats] then statistics
        when COMMANDS[:rules] then open_rules
        else
          puts I18n.t(:unexpected_command)
        end
      end
    end

    def receive_difficulty
      puts I18n.t(:level)
      loop do
        input_as_key = gets.chomp.to_sym
        if Codebreaker::Game::DIFFICULTIES.key?(input_as_key)
          return game.difficulty(Codebreaker::Game::DIFFICULTIES[input_as_key][:level])
        end

        puts I18n.t(:unexpected_level)
      end
    end

    def play_game
      receive_difficulty
      receive_name
      receive_game_code
      save_statistics
      play_again
    end

    def receive_game_code # rubocop:disable Metrics/AbcSize
      puts I18n.t(:enter_code)
      until game.end_game
        case code = gets.chomp
        when COMMANDS[:hint] then puts game.hint
        when REG_EXP_FOR_CODE then puts game.guess(code)
        else
          puts I18n.t(:unexpected_code)
        end
      end
    end

    def hint
      return game.hint unless game.hints.zero?

      puts I18n.t(:no_hint)
    end

    def receive_name
      puts I18n.t(:name)
      @name = gets.chomp
      validate
      puts errors
    end

    def play_again
      puts I18n.t(:play_again)
      return unless gets.chomp == COMMANDS[:yes]

      @game = Game.new
      play_game
    end

    def exit_message
      puts I18n.t(:goodbye)
    end

    def statistics
      if File.file?(PATH_STATS)
        File.open(PATH_STATS, 'r') { |f| puts f.read }
      else
        puts I18n.t(:no_file)
      end
    end

    def save_statistics
      File.open(PATH_STATS.to_s, 'a') do |f|
        f.puts name, game.statistics, Time.now
        f.puts '------------------------------'
      end
    end

    def open_rules
      File.open(PATH_RULES.to_s, 'r') { |f| puts f.read } if File.file?(PATH_RULES.to_s)
    end

    def validate
      errors << I18n.t('wrong_class', obj: name, klass: String) unless check_for_class?(name, String)
      errors << I18n.t('length_error') unless check_for_length?(name)
    end
  end
end
