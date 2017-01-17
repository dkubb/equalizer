# encoding: utf-8

if ENV['COVERAGE'] == 'true'
  require 'simplecov'

  SimpleCov.start do
    command_name 'spec:unit'

    add_filter 'config'
    add_filter 'spec'
    add_filter 'vendor'

    minimum_coverage 100
  end
end

require 'devtools/spec_helper'
require 'equalizer'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |expect_with|
    expect_with.syntax = :expect
  end

  config.around(:each) do |example|
    Timeout.timeout(5_000, &example)
  end
end
