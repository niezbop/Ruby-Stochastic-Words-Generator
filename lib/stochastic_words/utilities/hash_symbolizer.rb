module StochasticWords
  module Utilities
    class HashSymbolizer
      class << self
        def symbolize_hash(hash)
          hash.transform_keys do |key|
            key.to_sym
          end.transform_values do |value|
            process_value(value)
          end
        end

        private

        def process_value(value)
          if value.is_a?(Hash)
            symbolize_hash(value)
          elsif value.is_a?(Array)
            value.map { |item| process_value(item) }
          else
            value
          end
        end
      end
    end
  end
end