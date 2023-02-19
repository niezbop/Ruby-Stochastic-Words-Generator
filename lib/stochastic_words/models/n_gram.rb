module StochasticWords
  class NGram < ActiveRecord::Base
    class ItemList < Array
      class << self
        def load(string)
          return [] if string.nil?
          string.each_char.to_a
        end

        def dump(items)
          unless items.is_a?(Array)
            raise ::ActiveRecord::SerializationTypeMismatch,
              "Attribute was supposed to be a #{Array}, but was a #{items.class}. -- #{items.inspect}"
          end

          items.join
        end
      end
    end

    has_many :n_gram_character_associations
    has_many :following_characters, through: :n_gram_character_associations, source: :character

    validates :items, presence: true
    serialize :items, ItemList

    def n
      items.count
    end

    alias_method :count, :n
  end
end