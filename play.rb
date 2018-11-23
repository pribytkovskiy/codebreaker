require './modules/codebreaker.rb'

class Play
  include Codebreaker

  def initialize
    @game = Game.new
  end

  def play_game
    @game.difficulty
    puts 'Codebreaker! Make a guess of 4 numbers from 1 to 6.'
    puts "Enter code or comand 'hint' to hint, 'exit' to exit."
    while @game.exit? != true
      case code = gets.chomp
      when 'hint'
        puts @game.hint
      when 'exit'
        return
      when /\A[1-6]{4}\Z/
        puts @game.guess(code)
      else
        puts 'You should make a guess of 4 numbers from 1 to 6.'
      end
    end
    save
    statisctics
    play_again
  end

  private

  def play_again
    puts 'Would you like to play again? (y/n)'
    exit unless gets.chomp == 'y'
    @game = Game.new
    play_game
  end

  def statisctics
    puts 'Would you like look statisctics? (y,n)'
    return unless gets.chomp == 'y'

    File.open('./statisctics.txt', 'r') { |f| puts f.read }
  end

  def save
    puts 'Would you like to save game result? (y/n)'
    return unless gets.chomp == 'y'

    puts 'Your name'
    @name = gets.chomp
    File.open('./statisctics.txt', 'a') do |f|
      f.puts @name, @game.statistik, Time.now
      f.puts '------------------------------'
    end
  end
end

Play.new.play_game
