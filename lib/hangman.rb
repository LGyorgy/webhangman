require "yaml"

class Game
  def initialize
    @secret_word = load_dictionary(5, 12, "5desk.txt").sample.chomp.upcase
    @render_word = "_" * @secret_word.length
    @prev_letters = []
    @missed_letters = []
  end

  def load_dictionary(min_length, max_length, dictionary_path)
  dictionary = []
  File.open(dictionary_path).readlines.each do |line|
    dictionary << line.chomp if line.chomp.length >= min_length && line.chomp.length <= max_length
  end
  return dictionary
  end

  def get_letter
    letter = ""
    show_screen "Please choose a letter or save your game! (A-Z; SAVE)"
    loop do 
      letter = gets.chomp.upcase
      if letter == "SAVE"
        save_game
      elsif @prev_letters.include? letter
        show_screen("You already choose this letter. Please choose another one! (A-Z)")
      else
        break if ("A".."Z").include? letter
        show_screen "Invalid input! Try again!"
      end
    end
    @prev_letters << letter
    return letter
  end

  def evaluate_letter(selected_letter)
    found = false
    @secret_word.each_char.with_index do |letter, index|
      if letter == selected_letter
        @render_word[index] = @secret_word[index]
        found = true
      end
    end
    @missed_letters << selected_letter unless found
  end

  def save_game
    File.open("save.hmsv", "w+") do |file|
      file.puts YAML::dump(self)
    end
    show_screen "Game saved!\nPlease choose a letter or save your game! (A-Z; SAVE)"
  end

  def show_screen(message)
    system "clear"
    
    puts render_hangman
    puts "Missed letters: " + @missed_letters.join(", ") + "\n\n"
    puts @render_word
    puts "\n" + message
  end

  def render_hangman
    hangman = [['   +===+  ',   
               '   |   |  ',
               '       |  ',
               '       |  ',
               '       |  ',
               '       |  ',
               '=========='],
               ['   +===+  ',   
               '   |   |  ',
               '   O   |  ',
               '       |  ',
               '       |  ',
               '       |  ',
               '=========='],
               ['   +===+  ',   
               '   |   |  ',
               '   O   |  ',
               '   I   |  ',
               '       |  ',
               '       |  ',
               '=========='],
               ['   +===+  ',   
               '   |   |  ',
               '   O   |  ',
               '  /I   |  ',
               '       |  ',
               '       |  ',
               '=========='],
               ['   +===+  ',   
               '   |   |  ',
               '   O   |  ',
               '  /I\  |  ',
               '       |  ',
               '       |  ',
               '=========='],
               ['   +===+  ',   
               '   |   |  ',
               '   O   |  ',
               '  /I\  |  ',
               '  /    |  ',
               '       |  ',
               '=========='],
               ['   +===+  ',   
               '   |   |  ',
               '   O   |  ',
               '  /I\  |  ',
               '  / \  |  ',
               '       |  ',
               '==========']]

    puts hangman[@missed_letters.length]
  end

  def start
  loop do
    show_screen("Choose a letter")
    evaluate_letter(get_letter)
    if @secret_word == @render_word
      show_screen "You got it!"
      break
    elsif @missed_letters.length >= 6
      @render_word = @secret_word
      show_screen "Out of guesses. You lost!"
      break
    end
  end
  end
end

=begin
puts "Do you want to load your saved game?"
answere = gets.chomp.downcase
if ["yes", "y"].include? answere
  save_file = File.open("save.hmsv", "r")
  g = YAML::load(save_file)
else
  g = Game.new
end
g.start
=end