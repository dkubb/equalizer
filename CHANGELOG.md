# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-20

### Added

- Pattern matching support via `deconstruct` and `deconstruct_keys`
- Pretty print support via `pretty_print` and `pretty_print_instance_variables`
- Input validation requiring at least one Symbol attribute
- RBS type signatures
- Steep type checking
- Descriptive module names in ancestor chain (e.g., `Equalizer(x, y)`)
- Sigstore gem signing on release

### Changed

- Rewritten from a `Module` subclass to a plain `module` with `Equalizer.new`
  returning anonymous modules
- Minimum Ruby version raised to 3.3
- `hash` method now uses `[self.class, *deconstruct].hash` for improved clarity
- `inspect` output format uses `Object#to_s` base with `@attr=value` pairs
- Uses `public_send` instead of `__send__` for attribute access
- Switched test framework from RSpec to Minitest
- Replaced `Equalizer::Methods` module with `Equalizer::InstanceMethods`
- Inlined `VERSION` constant (removed separate `version.rb` file)

### Removed

- `coerce` support in `==` method
- `cmp?` private method (replaced with direct attribute comparisons)
- `Equalizer::Methods` module (replaced by `Equalizer::InstanceMethods`)
- devtools dependency

## [0.0.11] - 2015-03-23

### Changed

- Kill all surviving mutations in Equalizer
- Added mbj/devtools gem dependency
- Added bundler caching and container-based CI builds
- Fixed rspec deprecated API usage

## [0.0.10] - 2015-03-20

### Added

- Support for Ruby 2.1 and 2.2

### Fixed

- Fixed use of coerce method

### Changed

- Updated RSpec dependency to ~> 3.0
- Updated RuboCop dependency to >= 0.25
- Updated SimpleCov dependency to >= 0.9

### Removed

- Dropped support for Ruby 1.9.2

## [0.0.9] - 2013-12-23

### Changed

- Changed `#hash` method to use `Array#hash` for better uniformity
- Refactored block to use a Method object
- Removed devtools as a development dependency
- Added supported Ruby versions section to README

## [0.0.8] - 2013-12-02

### Fixed

- Fixed mutation in equality and equivalency methods
- Fixed mutation in comparison method

### Changed

- Refactored explicit method to be an included hook method
- Added spec for `Equalizer#included`
- Changed spec to verify private attributes can be compared

## [0.0.7] - 2013-08-22

### Changed

- Removed adamantium dependency
- Removed unused backports dependency
- Kill mutations in `Equalizer#define_cmp_method`
- Added license to gemspec
- Added mutant config and enabled mutation testing

### Removed

- Stopped testing Ruby 1.8

## [0.0.5] - 2013-03-01

### Changed

- Bumped backports dependency to ~> 3.0, >= 3.0.3
- Bumped yard dependency to ~> 0.8.5

## [0.0.4] - 2013-02-16

### Changed

- Added encoding to all Ruby source files
- Upgraded gem dependencies

## [0.0.3] - 2013-01-20

### Fixed

- Fixed `#hash` and `#inspect` methods to have the expected arity

## [0.0.2] - 2012-12-25

### Changed

- Changed `#==` to have stricter behavior for subtypes

## [0.0.1] - 2012-11-22

### Added

- Initial release, extracted from veritas
- Define equality (`==`), equivalence (`eql?`), hashing (`hash`), and
  inspection (`inspect`) methods based on specified attributes

[1.0.0]: https://github.com/dkubb/equalizer/compare/v0.0.11...v1.0.0
[0.0.11]: https://github.com/dkubb/equalizer/compare/v0.0.10...v0.0.11
[0.0.10]: https://github.com/dkubb/equalizer/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/dkubb/equalizer/compare/v0.0.8...v0.0.9
[0.0.8]: https://github.com/dkubb/equalizer/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/dkubb/equalizer/compare/v0.0.5...v0.0.7
[0.0.5]: https://github.com/dkubb/equalizer/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/dkubb/equalizer/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/dkubb/equalizer/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/dkubb/equalizer/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/dkubb/equalizer/releases/tag/v0.0.1
