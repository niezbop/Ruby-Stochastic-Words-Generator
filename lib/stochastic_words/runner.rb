require 'yaml'

module StochasticWords
  class Runner
    def self.from_file(configuration_file)
      raise ArgumentError, "#{configuration_file} is not a file" unless File.file?(configuration_file)
      return new(
        Utilities::HashSymbolizer.symbolize_hash(
          YAML.load(
            File.read(configuration_file))))
    end

    attr_reader :configuration, :random, :generator

    def initialize(configuration)
      @configuration = OpenStruct.new(configuration)

      # Setup the database
      Persistence.setup(**configuration[:persistence])

      # Flush and re-train if configured to do so or no database
      if configuration[:flush] or Persistence.empty?
        Persistence.define_tables
        parser = Parser.new(**configuration[:parser])
        configuration[:providers].each do |provider_setup|
          provider_class = Object.const_get("#{WordsProvider.name}::#{provider_setup[:name]}")
          parser << provider_class.new(**provider_setup[:configuration])
        end
      end

      @random = configuration[:seed] ? Random.new(configuration[:seed]) : Random.new
      @generator = Generator.new(**configuration[:generator].merge({ random: random }))
    end

    def get_word
      generator.generate_word
    end
  end
end