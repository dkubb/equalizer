# Equalizer

[![Gem Version](https://img.shields.io/gem/v/equalizer)](https://rubygems.org/gems/equalizer)
[![Test](https://github.com/dkubb/equalizer/actions/workflows/test.yml/badge.svg)](https://github.com/dkubb/equalizer/actions/workflows/test.yml)
[![Quality](https://github.com/dkubb/equalizer/actions/workflows/quality.yml/badge.svg)](https://github.com/dkubb/equalizer/actions/workflows/quality.yml)
[![Documentation](https://github.com/dkubb/equalizer/actions/workflows/yard.yml/badge.svg)](https://github.com/dkubb/equalizer/actions/workflows/yard.yml)
[![Mutation Testing](https://github.com/dkubb/equalizer/actions/workflows/mutant.yml/badge.svg)](https://github.com/dkubb/equalizer/actions/workflows/mutant.yml)

Equalizer provides equality, equivalence, hashing, pattern matching, and
inspection methods for Ruby objects based on explicitly specified attributes.

Unlike approaches that automatically use all `attr_reader` attributes,
Equalizer requires explicit specification of which attributes affect equality,
giving you full control over comparison behavior.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "equalizer"
```

Or install it directly:

```bash
gem install equalizer
```

## Quick Start

```ruby
class Point
  include Equalizer.new(:x, :y)

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

p1 = Point.new(1, 2)
p2 = Point.new(1, 2)

p1 == p2           # => true
p1.eql?(p2)        # => true
p1.hash == p2.hash # => true
```

## Features

### Selective Attribute Comparison

Only the attributes you specify are used for equality. Other instance variables
are ignored:

> [!TIP]
> This is useful when you have attributes that shouldn't affect equality, like
> timestamps, cached values, or display names.

```ruby
class GeoLocation
  include Equalizer.new(:latitude, :longitude)

  attr_reader :latitude, :longitude, :name

  def initialize(latitude, longitude, name = nil)
    @latitude = latitude
    @longitude = longitude
    @name = name
  end
end

home = GeoLocation.new(37.7786, -122.4407, "Home")
work = GeoLocation.new(37.7786, -122.4407, "Work")

home == work  # => true (name is not part of equality)
```

### Equality vs Equivalence

Equalizer provides two comparison methods with different semantics:

#### `==` (Equality)

Returns `true` if the other object is an instance of the same class **or a
subclass**, and all specified attributes are equal using `==`:

```ruby
class ColoredPoint < Point
  attr_reader :color

  def initialize(x, y, color)
    super(x, y)
    @color = color
  end
end

point = Point.new(1, 2)
colored = ColoredPoint.new(1, 2, "red")

point == colored   # => true (ColoredPoint is a subclass of Point)
colored == point   # => false (Point is not a subclass of ColoredPoint)
```

> [!IMPORTANT]
> In Ruby, the `==` operator is asymmetric when comparing across class
> hierarchies. A parent class instance can equal a subclass instance, but not
> vice versa.

#### `eql?` (Equivalence)

Returns `true` only if both objects are instances of the **exact same class**,
and all specified attributes are equal using `eql?`:

```ruby
point = Point.new(1, 2)
colored = ColoredPoint.new(1, 2, "red")

point.eql?(colored)   # => false (different classes)
colored.eql?(point)   # => false (different classes)

point.eql?(Point.new(1, 2))  # => true (same class, same values)
```

### Hashing

Objects that are `eql?` will have the same hash code, making them safe for use
as Hash keys and in Sets:

> [!NOTE]
> Ruby's `Hash` and `Set` use `eql?` and `hash` together. Equalizer ensures
> these methods stay consistent—objects that are `eql?` always have matching
> hash codes.

```ruby
require "set"

p1 = Point.new(1, 2)
p2 = Point.new(1, 2)

# As Hash keys
locations = {}
locations[p1] = "first"
locations[p2] = "second"
locations.size  # => 1 (p1 and p2 are the same key)

# In Sets
set = Set.new
set << p1
set << p2
set.size  # => 1
```

### Pattern Matching

Equalizer provides full support for Ruby's pattern matching syntax.

> [!TIP]
> Use array patterns `[x, y]` for positional matching when attribute order
> matters. Use hash patterns `{x:, y:}` for named matching when you want
> clarity or only need specific attributes.

#### Array Patterns

Use `deconstruct` for array-style pattern matching:

```ruby
point = Point.new(3, 4)

case point
in [0, 0]
  puts "origin"
in [x, 0]
  puts "on x-axis at #{x}"
in [0, y]
  puts "on y-axis at #{y}"
in [x, y]
  puts "at (#{x}, #{y})"
end
# => "at (3, 4)"
```

#### Hash Patterns

Use `deconstruct_keys` for hash-style pattern matching:

```ruby
point = Point.new(3, 4)

case point
in { x: 0, y: 0 }
  puts "origin"
in { x:, y: } if x == y
  puts "on diagonal at #{x}"
in { x:, y: }
  puts "at (#{x}, #{y})"
end
# => "at (3, 4)"
```

#### Class Patterns

Combine with class checks:

```ruby
case point
in Point(x: 0, y: 0)
  puts "origin point"
in Point(x:, y:)
  puts "point at (#{x}, #{y})"
end
```

### Clean Inspect Output

Equalizer customizes `inspect` to show only the attributes used for equality:

```ruby
class User
  include Equalizer.new(:id)

  attr_reader :id, :name, :email, :created_at

  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
    @created_at = Time.now
  end
end

user = User.new(42, "Alice", "alice@example.com")
user.inspect
# => "#<User:0x00007f... @id=42>"
# Note: name, email, and created_at are not shown
```

> [!NOTE]
> When debugging, remember that `inspect` only shows equality attributes. Use
> `instance_variables` to see all instance variables if needed.

To keep the original `inspect` and `pretty_print` methods, pass `inspect: false`:

```ruby
class Person < Struct.new(:id, :name)
  include Equalizer.new(:id, inspect: false)
end

amy = Person.new(1, "Amy")
amy.inspect
# => "#<struct Person id=1, name=\"Amy\">"
```

### Clean Ancestor Chain

The included module has a descriptive name in the ancestor chain:

```ruby
Point.ancestors
# => [Point, Equalizer(x, y), Object, Kernel, BasicObject]
```

## Nested Equalizer Objects

Equalizer objects can be nested and will compare correctly:

```ruby
class Line
  include Equalizer.new(:start_point, :end_point)

  attr_reader :start_point, :end_point

  def initialize(start_point, end_point)
    @start_point = start_point
    @end_point = end_point
  end
end

line1 = Line.new(Point.new(0, 0), Point.new(1, 1))
line2 = Line.new(Point.new(0, 0), Point.new(1, 1))

line1 == line2  # => true
```

## Error Handling

> [!CAUTION]
> Equalizer validates arguments at include time. Errors will be raised
> immediately if you pass invalid arguments.

Equalizer validates its arguments:

```ruby
# At least one attribute is required
Equalizer.new()
# => ArgumentError: at least one attribute is required

# Attributes must be Symbols
Equalizer.new("name")
# => ArgumentError: attribute must be a Symbol, got String
```

## Supported Ruby Versions

This library aims to support and is [tested against][test] the following Ruby
implementations:

* Ruby 3.3
* Ruby 3.4
* Ruby 4.0

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

[test]: https://github.com/dkubb/equalizer/actions/workflows/test.yml

## Credits

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Markus Schirp ([mbj](https://github.com/mbj))
* Piotr Solnica ([solnic](https://github.com/solnic))
* Erik Berlin ([sferik](https://github.com/sferik))

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).
