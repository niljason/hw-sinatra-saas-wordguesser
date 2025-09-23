class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if !(letter =~ /[a-zA-Z]/)
      raise ArgumentError
    end
    letter = letter.downcase
    if guesses.include?(letter) || wrong_guesses.include?(letter)
      return false
    end  
    if word.include?(letter)
      self.guesses += letter
    else
      self.wrong_guesses += letter
    end
    true
  end

  def guess_several_letters(letters)
    word.each_char do |ch|
      self.guess(ch)
    end
  end

  def word_with_guesses()
    result = ""
    word.each_char do |ch|
      if guesses.include?(ch)
        result += ch
      else
        result += "-"
      end
    end
    result
  end

  def check_win_or_lose()
    state = word_with_guesses
    if wrong_guesses.size >= 7
      return :lose
    end
    
    if state == word
      return :win
    end

    return :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
