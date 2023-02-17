module StochasticWords
  class NGramCharacterAssociation < ActiveRecord::Base
    belongs_to :n_gram
    belongs_to :character

    validates :count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
    validates :character_id, uniqueness: { scope: :n_gram_id }
  end
end