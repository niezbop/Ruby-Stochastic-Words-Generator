module StochasticWords
  class NGram < ActiveRecord::Base
    has_many :n_gram_character_associations
    has_many :following_characters, through: :n_gram_character_associations, source: :character

    validates :items, presence: true
    serialize :items, Array

    def n
      items.count
    end

    alias_method :count, :n
  end
end