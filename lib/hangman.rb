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
    print "Please guess a letter: "
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

  def play
    puts "Welcome to Hangman!"
    puts @secret_word
    while game_on?
      print_board
      make_guess
      if valid_guess?
        update_board
        display
      else
        puts "Invalid guess. Try again."
      end
    end
  end

end

Game.new.play
