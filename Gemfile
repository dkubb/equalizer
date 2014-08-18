# encoding: utf-8

source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'backports'
  gem 'coveralls'
  gem 'json',       :platforms => [:ruby_19]
  gem 'mime-types', '~> 1.25', :platforms => [:jruby, :ruby_18]
  gem 'rest-client', '~> 1.6.0', :platforms => [:jruby, :ruby_18]
  gem 'rspec',      '~> 3.0'
  gem 'rubocop',    '>= 0.23', :platforms => [:ruby_19, :ruby_20, :ruby_21]
  gem 'simplecov',  '>= 0.9'
  gem 'yardstick'
end

gemspec
