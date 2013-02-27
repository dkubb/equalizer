# encoding: utf-8

require File.expand_path('../lib/equalizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'equalizer'
  gem.version     = Equalizer::VERSION.dup
  gem.authors     = ['Dan Kubb', 'Markus Schirp']
  gem.email       = %w[dan.kubb@gmail.com mbj@seonic.net]
  gem.description = 'Module to define equality, equivalence and inspection methods'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/dkubb/equalizer'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- {spec}/*`.split($/)
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_runtime_dependency('backports',  [ '~> 3.0', '>= 3.0.3' ])
  gem.add_runtime_dependency('adamantium', '~> 0.0.6')

  gem.add_development_dependency('rake',  '~> 10.0.3')
  gem.add_development_dependency('rspec', '~> 1.3.2')
  gem.add_development_dependency('yard',  '~> 0.8.5')
end
