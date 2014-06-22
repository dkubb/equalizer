# encoding: utf-8

source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'backports'
  gem 'coveralls', :require => false
  gem 'json',      :platforms => [:ruby_19]
  gem 'rspec',     '~> 2.14'
  gem 'rubocop',   '>= 0.23', :platforms => [:ruby_19, :ruby_20, :ruby_21]
  gem 'simplecov', :require => false
  gem 'yardstick'
end

platforms :jruby, :ruby_18 do
  gem 'mime-types', '~> 1.25'
end

gemspec
