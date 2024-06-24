equalizer
=========

Module to define equality, equivalence and inspection methods

[![Gem Version](http://img.shields.io/gem/v/equalizer.svg)][gem]
[![Build Status](https://github.com/dkubb/equalizer/actions/workflows/specs.yml/badge.svg)][specs]
[![Mutant](https://github.com/dkubb/equalizer/actions/workflows/mutant.yml/badge.svg)][mutant]
[![Standard](https://github.com/dkubb/equalizer/actions/workflows/standard.yml/badge.svg)][standard]
[![Yardstick](https://github.com/dkubb/equalizer/actions/workflows/yardstick.yml/badge.svg)][yardstick]

[gem]: https://rubygems.org/gems/equalizer
[specs]: https://github.com/dkubb/equalizer/actions/workflows/specs.yml
[mutant]: https://github.com/dkubb/equalizer/actions/workflows/mutant.yml
[standard]: https://github.com/dkubb/equalizer/actions/workflows/standard.yml
[yardstick]: https://github.com/dkubb/equalizer/actions/workflows/yardstick.yml

Examples
--------

``` ruby
class GeoLocation
  include Equalizer.new(:latitude, :longitude)

  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude, @longitude = latitude, longitude
  end
end

point_a = GeoLocation.new(1, 2)
point_b = GeoLocation.new(1, 2)
point_c = GeoLocation.new(2, 2)

point_a.inspect    # => "#<GeoLocation latitude=1 longitude=2>"

point_a == point_b           # => true
point_a.hash == point_b.hash # => true
point_a.eql?(point_b)        # => true
point_a.equal?(point_b)      # => false

point_a == point_c           # => false
point_a.hash == point_c.hash # => false
point_a.eql?(point_c)        # => false
point_a.equal?(point_c)      # => false

class Person < Struct.new(:id, :name)
  include Equalizer.new(:id, define_inspect: false)
end

amy = Person.new(1, "Amy")

amy.inspect   # => '#<struct Person id=1, name="Amy">'
```

Supported Ruby Versions
-----------------------

This library aims to support and is [tested against][specs] the following Ruby
implementations:

* Ruby 3.1
* Ruby 3.2
* Ruby 3.3

If something doesn't work on one of these versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby versions or
implementations, however support will only be provided for the implementations
listed above.

If you would like this library to support another Ruby version or
implementation, you may volunteer to be a maintainer. Being a maintainer
entails making sure all tests run and pass on that implementation. When
something breaks on your implementation, you will be responsible for providing
patches in a timely fashion. If critical issues for a particular implementation
exist at the time of a major release, support for that Ruby version may be
dropped.

Credits
-------

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Piotr Solnica ([solnic](https://github.com/solnic))
* Markus Schirp ([mbj](https://github.com/mbj))
* Erik Berlin ([sferik](https://github.com/sferik))

Contributing
-------------

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

Copyright
---------

Copyright &copy; 2009-2024 Dan Kubb. See LICENSE for details.
