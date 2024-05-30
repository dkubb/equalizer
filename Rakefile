require "rspec/core/rake_task"
require "bundler/gem_tasks"
require "standard/rake"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

require "yardstick/rake/verify"
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 100
end

task default: [:spec]
