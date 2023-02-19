module StochasticWords
  class Character < ActiveRecord::Base
    has_many :n_gram_character_associations
    has_many :following_characters, through: :n_gram_character_associations, source: :character

    validates :value,
      presence: true,
      length: { is: 1 },
      allow_blank: true,
      uniqueness: true
  end
end