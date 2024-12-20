# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stochastic_words/version'

Gem::Specification.new do |spec|
  spec.name        = 'stochastic_words'
  spec.version     = StochasticWords::VERSION
  spec.authors     = ['Paul Niezborala']
  spec.email       = 'paulniezbo@gmail.com'

  spec.required_ruby_version = '>= 2.5.0'

  spec.summary     = 'Stochastic Words is a library built on top of Markov Chains to generate words from a set of other words.'
  spec.description = '' # TODO: add description

  spec.homepage    = 'https://github.com/niezbop/Ruby-Stochastic-Words-Generator'
  spec.license     = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'yaml'
  spec.add_dependency 'activerecord'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'httparty'
  spec.add_dependency 'nokogiri'
end