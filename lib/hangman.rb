require 'yaml'

class Game

  DICTIONARY = File.readlines("5desk.txt").select { |word| word.strip.length.between?(5,12) }

  def initialize
    @secret_word = DICTIONARY.sample.strip.downcase
    @board = Array.new(@secret_word.length, "__")
    @guess = nil
    @misses = []
  end

  def print_board
    puts
    puts @board.join(" ")
  end

  def make_guess
    print "Please guess a letter (or type 'save' to save and exit): "
    @guess = gets.chomp.downcase
  end

  def valid_guess?
    @guess =~ /^[a-z]$/
  end

  def update_board
    if @secret_word.include?(@guess)
      puts "Your guess was correct!"
      @secret_word.split(//).each_with_index do |letter, index|
        @board[index] = letter if letter == @guess
      end
    else
      puts "Your guess was a miss."
      @misses << @guess
    end
  end

  def display
    puts "Misses: " + (@misses.empty? ? "none" : @misses.join(","))
    puts "You have #{6 - @misses.length} incorrect guesses remaining."
  end

  def game_on?
    if @misses.length == 6
      puts "Game over. The correct word was #{@secret_word}."
      return false
    elsif @board.none? {|letter| letter == "__"}
      puts "You win!"
      return false
    else
      return true
    end
  end

  def save_game
    Dir.mkdir('saved_games') unless Dir.exist?("saved_games")
    File.open('saved_games/game.yaml', 'w') do |file|
      file.puts YAML::dump(self)
    end
  end

  def play
    while game_on?
      print_board
      make_guess
      if @guess == 'save'
        save_game
        return
      elsif valid_guess?
        update_board
        display
      else
        puts "Invalid guess. Try again."
      end
    end
  end

end


def main
  puts "Welcome to Hangman!"
  loop do
    puts "Would you like to load a previously saved game? (y/n)"
    input = gets.chomp.downcase
    case input
    when 'y'
      load_game.play
      break
    when 'n'
      Game.new.play
      break
    else
      puts "Invalid entry."
    end
  end
end

def load_game
  contents = File.read('saved_games/game.yaml')
  puts contents
  YAML::load(contents)
end

main
