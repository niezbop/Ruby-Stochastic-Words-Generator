require 'httparty'
require 'nokogiri'

module StochasticWords::WordsProvider
  class HTTPProvider
    attr_reader :url, :xpath

    def initialize(url:, xpath:)
      @url = url
      @xpath = xpath
    end

    def each_word
      data = HTTParty.get(url).body
      html = Nokogiri::HTML(data)

      html.xpath(xpath)
        .map(&:text)
        .map { |word| [ word, 1 ] }
        .map { |word, frequency| yield [ word, frequency ] }
    end
  end
end