module Codebreaker
  class Storage
    PATH_RULES = './db/rules.txt'.freeze
    PATH_STATS = './db/statistics.txt'.freeze
    SEPARATOR = '------------------------------'.freeze
    STATUS = { no_file: :no_file }.freeze

    class << self
      def save_statistics(name, game)
        File.open(PATH_STATS.to_s, 'a') do |f|
          f.puts name, statistics(game), Time.now
          f.puts SEPARATOR
        end
      end

      def open_statistics
        if File.file?(PATH_STATS)
          File.open(PATH_STATS, &:read)
        else
          STATUS[:no_file]
        end
      end

      def open_rules
        File.open(PATH_RULES.to_s, &:read) if File.file?(PATH_RULES.to_s)
      end

      private

      def statistics(game)
        I18n.t(
          :statistics, status: game_status(game), level: game.difficult[:level],
          secret_code: game.secret_code, total_attempts: game.difficult[:attempts],
          attempts_used: attempts_used(game), total_hints: game.difficult[:hints],
          hints_used: hints_used(game)
        )
      end

      def attempts_used(game)
        game.difficult[:attempts] - game.attempts
      end

      def hints_used(game)
        game.difficult[:hints] - game.hints
      end

      def game_status(game)
        case game.game_status
        when :win then I18n.t(:win)
        when :no_attempts then I18n.t(:no_attempts)
        end
      end
    end
  end
end
