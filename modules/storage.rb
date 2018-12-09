module Codebreaker
  class Storage
    PATH_RULES = './db/rules.txt'.freeze
    PATH_STATS = './db/statisctics.txt'.freeze

    class << self
      private

      def statisctics
        if File.file?(PATH_STATS.to_s)
          File.open(PATH_STATS.to_s, 'r') { |f| puts f.read }
        else
          puts I18n.t(:no_file)
        end
      end

      def save(name, game)
        File.open(PATH_STATS.to_s, 'a') do |f|
          f.puts name, game.statistik, Time.now
          f.puts '------------------------------'
        end
      end

      def open_rules
        File.open(PATH_RULES.to_s, 'r') { |f| puts f.read } if File.file?(PATH_RULES.to_s)
      end
    end
  end
end
