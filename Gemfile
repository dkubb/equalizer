# encoding: utf-8

source 'https://rubygems.org'

gemspec

gem 'backports', '~> 2.6.1'

group :development do
  gem 'rake',  '~> 10.0.2'
  gem 'rspec', '~> 1.3.2'
  gem 'yard',  '~> 0.8.1'
end

group :guard do
  gem 'guard',         '~> 1.5.4'
  gem 'guard-bundler', '~> 1.0.0'
  gem 'guard-rspec',   '~> 1.2.1'
  gem 'rb-inotify'
end

group :benchmarks do
  gem 'rbench', '~> 0.2.3'
end

platform :jruby do
  group :jruby do
    gem 'jruby-openssl', '~> 0.7.4'
  end
end

group :metrics do
  gem 'flay',            '~> 1.4.3'
  gem 'flog',            '~> 2.5.3'
  gem 'reek',            '~> 1.2.8', :github => 'dkubb/reek'
  gem 'roodi',           '~> 2.1.0'
  gem 'yardstick',       '~> 0.8.0'
  gem 'yard-spellcheck', '~> 0.1.5'

  platforms :mri_18 do
    gem 'arrayfields', '~> 4.7.4'  # for metric_fu
    gem 'fattr',       '~> 2.2.0'  # for metric_fu
    gem 'heckle',      '~> 1.4.3'
    gem 'json',        '~> 1.7.3'  # for metric_fu rake task
    gem 'map',         '~> 6.2.0'  # for metric_fu
    gem 'metric_fu',   '~> 2.1.1'
    gem 'mspec',       '~> 1.5.17'
    gem 'rcov',        '~> 1.0.0'
    gem 'ruby2ruby',   '= 1.2.2'   # for heckle
  end

  platforms :rbx do
    gem 'pelusa', '~> 0.2.1'
  end
end
