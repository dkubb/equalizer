source 'https://rubygems.org'

gem 'rake', '>= 12.3.3'

group :test do
  gem 'rspec'
  gem 'simplecov', require: false, platforms: :ruby
  gem 'simplecov-cobertura', require: false, platforms: :ruby
  gem 'warning' if RUBY_VERSION >= '2.4.0'
end

group :tools do
  gem 'rubocop', '>= 1.26.1'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
end

group :docs do
  gem "redcarpet"
  gem "yard"
  gem "yard-junk"
end

gemspec
