# encoding: utf-8

source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'coveralls', :require => false
  gem 'rspec',     '~> 2.14'
  gem 'simplecov', :require => false
end

platforms :jruby, :ruby_18 do
  gem 'mime-types', '~> 1.25'
end

platforms :rbx do
  gem 'rubinius-coverage',  '~> 2.0'
  gem 'rubysl', '~> 2.0'
end

gemspec
