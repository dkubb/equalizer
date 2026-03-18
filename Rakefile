# frozen_string_literal: true

require "bundler/gem_tasks"

# Override release task to only tag and push to git
# The GitHub Action (push.yml) handles the actual gem push
Rake::Task["release"].clear
desc "Create tag v#{Equalizer::VERSION} and push to GitHub"
task "release", [:remote] => ["build", "release:guard_clean"] do |_, args|
  Rake::Task["release:source_control_push"].invoke(args[:remote])
end
require "rake/testtask"
require "standard/rake"
require "rubocop/rake_task"
require "yard"
require "yardstick/rake/verify"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = true
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = %w[--display-cop-names]
end

YARD::Rake::YardocTask.new(:yard) do |t|
  t.files = ["lib/**/*.rb"]
  t.options = ["--no-private", "--markup", "markdown"]
end

Yardstick::Rake::Verify.new(:yardstick) do |verify|
  verify.threshold = 100
  verify.require_exact_threshold = false
end

desc "Run Steep type checker"
task :steep do
  sh "steep check"
end

desc "Run mutation testing"
task :mutant do
  ENV["MUTANT"] = "true"
  sh "bundle exec mutant run"
end

desc "Run all quality checks"
task quality: %i[rubocop steep yardstick]

desc "Run all checks (tests, quality, mutation)"
task default: %i[test quality mutant]
