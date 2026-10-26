# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development, :test do
  gem "minitest", ">= 6"
  gem "rake", ">= 13.3"
  gem "simplecov", ">= 1", require: false

  # Linting
  gem "rubocop", ">= 1.82"
  gem "rubocop-minitest", ">= 0.38"
  gem "rubocop-performance", ">= 1.26"
  gem "rubocop-rake", ">= 0.7"
  gem "standard", ">= 1.53"
  gem "standard-performance", ">= 1.9"

  # Type checking
  gem "steep", ">= 1.10"

  # Performance regression guards
  # Duel requires Ruby 3.4 or later
  gem "duel", ">= 0.1.1" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4")

  # Documentation
  gem "yard", ">= 0.9"
  gem "yardstick", ">= 0.9"

  # Mutation testing
  gem "mutant-minitest", ">= 0.14"
  gem "stackprof", platforms: :mri
end
