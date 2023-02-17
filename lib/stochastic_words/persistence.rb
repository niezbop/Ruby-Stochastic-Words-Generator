require 'yaml'

module StochasticWords
  module Persistence
    def self.setup(persist_to: ':memory:')
      ActiveRecord::Base.logger = Logger.new(STDERR)

      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: persist_to
      )

      ActiveRecord::Schema.define do
        create_table :n_grams, force: :cascade do |table|
          table.text :items, default: [].to_yaml, null: false
        end
    
        create_table :characters, force: :cascade do |table|
          table.string :value, limit: 1, null: false
        end

        create_table :n_gram_character_associations, force: :cascade, id: false do |table|
          table.integer :count, default: 0, null: false
          table.references :n_gram, index: true
          table.references :character, index: true
          table.index [:n_gram, :character], name: "index_n_gram_character_associations_uniqueness", unique: true
        end
      end
    end
  end
end