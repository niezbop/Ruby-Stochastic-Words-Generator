require_relative 'special_characters'

module StochasticWords
  class Generator
    attr_reader :gram_size, :random

    def initialize(gram_size:, random: nil)
      @gram_size = gram_size
      @random = random || Random.new
    end

    def generate_word
      n_gram = NGram.new(items: [ SpecialCharacters::INITIAL_CHARACTER ] * gram_size)
      word = ''

      loop do
        character = GetCharacterForNGram.run(n_gram, random).value
        break if character == SpecialCharacters::FINISHING_CHARACTER

        word += character
        n_gram = NGram.new(items: n_gram.items.push(character).last(n_gram.n))
      end

      return word
    end
  end
end