module StochasticWords
  module Persistence
    def self.setup(persist_to: ':memory:')
      ActiveRecord::Base.logger = Logger.new(STDERR)

      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: persist_to
      )
    end

    def self.define_tables
      ActiveRecord::Schema.define do
        create_table :n_grams, force: :cascade do |table|
          table.string :items, default: '', null: false
          table.index [:items], name: "index_n_grams_on_items_uniqueness", unique: true
        end
    
        create_table :characters, force: :cascade do |table|
          table.string :value, limit: 1, null: false
          table.index [:value], name: "index_characters_on_value_uniqueness", unique: true
        end

        create_table :n_gram_character_associations, force: :cascade do |table|
          table.integer :count, default: 0, null: false
          table.references :n_gram, index: true
          table.references :character, index: true
          table.index [:n_gram_id, :character_id], name: "index_n_gram_character_associations_uniqueness", unique: true
        end
      end
    end

    def self.empty?
      !ActiveRecord::Base.connection.tables.any?
    end
  end
end