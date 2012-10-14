# -*- encoding: utf-8 -*-

require File.expand_path('../lib/equalizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'equalizer'
  gem.version     = Equalizer::VERSION.dup
  gem.authors     = [ 'Dan Kubb' ]
  gem.email       = [ 'dan.kubb@gmail.com' ]
  gem.description = 'Module to define equality, equivalence and inspection methods'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/dkubb/equalizer'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_dependency 'ice_nine',   '~> 0.4.0'
  gem.add_dependency 'adamantium', '~> 0.0.1'
end
