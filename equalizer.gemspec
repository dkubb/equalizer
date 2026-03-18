# frozen_string_literal: true

require_relative "lib/equalizer"

Gem::Specification.new do |spec|
  spec.name = "equalizer"
  spec.version = Equalizer::VERSION
  spec.authors = ["Dan Kubb", "Markus Schirp", "Piotr Solnica", "Erik Berlin"]
  spec.email = ["dan.kubb@gmail.com", "mbj@schirp-dso.com", "piotr.solnica@gmail.com", "sferik@gmail.com"]

  spec.summary = "Define equality, equivalence, and " \
    "hashing methods for Ruby objects"
  spec.description = <<~DESCRIPTION
    Equalizer provides a simple way to define equality
    (==), equivalence (eql?), and hashing (hash) methods
    for Ruby objects based on specified attributes. Includes
    pattern matching support and clean inspect output.
  DESCRIPTION
  spec.homepage = "https://github.com/dkubb/equalizer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://rubydoc.info/gems/equalizer/",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => spec.homepage
  }

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(
          "bin/", "test/", "spec/", "features/",
          ".git", ".github", "Gemfile"
        )
    end
  end
  spec.require_paths = ["lib"]
end
