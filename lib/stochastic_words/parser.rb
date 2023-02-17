module StochasticWords
  class Parser
    INITIAL_CHARACTER = nil.freeze
    FINISHING_CHARACTER = "\004".freeze

    attr_reader :gram_size

    def initialize(gram_size:)
      @gram_size = gram_size
    end

    def parse(provider)
      provider.each_word do |word, frequency|
        state = [ INITIAL_CHARACTER ] * gram_size

        (0..word.length() - 1).each do |character_index|
          current_character_value = word[character_index]

          count_association(state, current_character_value, frequency)

          # Change state to move to the next character
          state.push(current_character_value).shift
        end

        # Finish the word
        count_association(state, FINISHING_CHARACTER, frequency)
      end
    end

    alias_method :<<, :parse

    def count_association(state, character_value, frequency)
      # Find or create the appropriate entries in the database
      n_gram = NGram.find_or_create_by!(items: state)
      character = Character.find_or_create_by!(value: character_value)

      association = NGramCharacterAssociation.find_or_create_by!(n_gram: n_gram, character: character)
      puts association.inspect
      association.increment!(:count, frequency)
    end
  end
end