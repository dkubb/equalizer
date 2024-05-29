require "rspec/core/rake_task"
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec)

begin
  require "yard-junk/rake"
  YardJunk::Rake.define_task(:text)
rescue LoadError
end

task default: [:spec]
