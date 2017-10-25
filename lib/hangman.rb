require "yaml"

class Game
  attr_reader :secret_word, :render_word, :prev_letters, :missed_letters
  def initialize
    @secret_word = load_dictionary(5, 12, "./lib/5desk.txt").sample.chomp.upcase
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

  def guess(letter)
    response = :none
    letter = letter.to_s.upcase
    
    if win?
      response == :win
    elsif letter == "SAVE"
      save_game
      response = :saved
    elsif letter == "LOAD"
      load_game
      response = :loaded
    elsif @prev_letters.include? letter
      response = :repeat
    elsif  ("A".."Z").include? letter
      evaluate_letter(letter) ? response = :found : response = :miss
      @prev_letters << letter
    end

    response
  end

  def win?
    @secret_word == @render_word
  end

  def get_status
    {render_word:       @render_word,
     missed_letters:    @missed_letters,
     win:               win?}
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
    return found
  end

  def save_game
    File.open("save.hmsv", "w+") do |file|
      file.puts YAML::dump(self)
    end
  end

  def load_game
    save_file = File.open("save.hmsv", "r")
    g = YAML::load(save_file)
    @secret_word = g.secret_word
    @render_word = g.render_word
    @prev_letters = g.prev_letters
    @missed_letters = g.missed_letters
  end
end