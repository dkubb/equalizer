require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'standard/rake'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

begin
  require "yard-junk/rake"
  YardJunk::Rake.define_task(:text)
rescue LoadError
end

task default: [:spec]
