module StochasticWords
  # Get at random using weighted reservoir sampling
  class GetCharacterForNGram
    class EmptySetError < StandardError
    end

    def self.run(n_gram, random = nil)
      random ||= Random.new
      get_character_for_n_gram(n_gram, random)
    end

    private

    def self.get_character_for_n_gram(n_gram, random)
      return get_character(n_gram.to_predicate, random)
    rescue EmptySetError # There is no character possible for this n-gram
      if n_gram.n > 1 # If we can check a shorter sequence of character
        get_character_for_n_gram(NGram.new(items: n_gram.items.last(n_gram.n - 1)), random) # Katz's back-off
      else
        get_character_for_n_gram(NGram.where.not(id: nil)) # Fallback on straight probability of character occurence, regardless of preceding n-gram
      end
    end

    def self.get_character(n_gram_predicate, random)
      character_id_count = NGramCharacterAssociation
        .joins(:n_gram)
        .merge(n_gram_predicate)
        .group(:character_id)
        .sum(:count)

      raise EmptySetError if character_id_count.empty?

      character_id_weights = character_id_count.transform_values { |count| count.to_f / character_id_count.values.sum }

      # Weighted Random Sampling using reservoir method
      character_id = character_id_weights.max_by { |_id, weight| random.rand ** (1.0 / weight) }.first

      return Character.find(character_id)
    end
  end
end