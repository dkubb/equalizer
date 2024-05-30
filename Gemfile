source "https://rubygems.org"

gem "rake", ">= 12.3.3"

group :test do
  gem "mutant", ">= 0.12"
  gem "mutant-rspec"
  gem "rspec"
  gem "simplecov", require: false, platforms: :ruby
  gem "simplecov-cobertura", require: false, platforms: :ruby
  gem "warning" if RUBY_VERSION >= "2.4.0"
end

group :tools do
  gem "rubocop", ">= 1.26.1"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "standard", ">= 1.35.1"
end

group :docs do
  gem "yard"
  gem "yardstick"
end

gemspec
