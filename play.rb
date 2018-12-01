require './modules/codebreaker.rb'

class Play
  include Codebreaker

  attr_reader :game

  def initialize
    @game = Game.new
  end

  def introduction
    puts "Welcome! Enter comand 'start', 'rules', 'stats', 'exit'."
    case gets.chomp
    when 'start'
      play_game
    when 'exit'
      puts 'Goodbye message!'
      return
    when 'stats'
      statisctics
      introduction
    when 'rules'
      File.open('./db/rules.txt', 'r') { |f| puts f.read }
      introduction
    else
      puts 'You have passed unexpected command. Please choose one from listed commands.'
      introduction
    end
  end

  private

  def difficulty
    puts "Please enter level
          easy - 15 attempts. 2 hints
          medium - 10 attempts. 1 hint
          hell - 5 attempts. 1 hint"
    case gets.chomp
    when 'easy'
      @game.difficulty(:easy, 15, 2)
    when 'medium'
      @game.difficulty(:medium, 10, 1)
    when 'hell'
      @game.difficulty(:hell, 5, 1)
    else
      puts 'You should enter: easy, medium, hell'
      difficulty
    end
  end

  def play_game
    difficulty
    name
    puts "Codebreaker! Make a guess of 4 numbers from 1 to 6. Enter code or comand 'hint' to hint."
    while @game.exit? != true
      case code = gets.chomp
      when 'hint'
        puts @game.hint
      when /\A[1-6]{4}\Z/
        puts @game.guess(code)
      when 'exit'
        puts 'Goodbye message!'
        return
      else
        puts 'You should make a guess of 4 numbers from 1 to 6.'
      end
    end
    save
    play_again
  end

  def name
    puts 'Your name.'
    @name = gets.chomp
    if (@name.length >= 3) && (@name.length <= 20) && (@name.is_a? String)
      return
    else
      puts 'String, required, min length - 3 symbols, max length - 20 symbols.'
    end
  end

  def play_again
    puts 'Would you like to play again? (y/n)'
    exit unless gets.chomp == 'y'
    @game = Game.new
    play_game
  end

  def statisctics
    File.open('./db/statisctics.txt', 'r') { |f| puts f.read }
  end

  def save
    File.open('./db/statisctics.txt', 'a') do |f|
      f.puts @name, @game.statistik, Time.now
      f.puts '------------------------------'
    end
  end
end

#Play.new.introduction
