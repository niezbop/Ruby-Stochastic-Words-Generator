module StochasticWords::WordsProvider
  class DictionaryFileProvider
    attr_reader :file_path

    SHARED_WORDS_DICTIONARY_PATH = '/usr/share/dict/words'.freeze

    def initialize(file_path:)
      @file_path = file_path
    end

    def each_word
      expanded_path = File.expand_path(file_path)
      raise ArgumentError, "No file at #{expanded_path}" unless File.file? expanded_path

      File.readlines(file_path).map do |line|
        [line.strip, 1]
      end.each { |word, frequency| yield [word, frequency] }
    end
  end
end