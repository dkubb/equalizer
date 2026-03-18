# frozen_string_literal: true

unless ENV["MUTANT"]
  require "simplecov"

  SimpleCov.start do
    enable_coverage :branch
    minimum_coverage line: 100, branch: 100
    add_filter %r{^/test/}
    add_group "Lib", "lib"
  end
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "equalizer"

if ENV["MUTANT"]
  require "mutant/minitest/coverage"
  require "minitest"
else
  require "minitest/autorun"
  Minitest::Test.define_singleton_method(:cover) { |_expression| nil }
end

class EqualizerTestCase < Minitest::Test
  cover "Equalizer*"
end

# Primary fixture: 2 equalizer attributes + 1 non-equalizer attribute
class Point
  include Equalizer.new(:x, :y)

  attr_reader :x, :y, :label

  def initialize(x, y, label = nil)
    @x = x
    @y = y
    @label = label
  end
end

# Subclass fixture for inheritance testing
class ColoredPoint < Point
  attr_reader :color

  def initialize(x, y, color)
    super(x, y)
    @color = color
  end
end

# Single attribute fixture
class Wrapper
  include Equalizer.new(:value)

  attr_reader :value

  def initialize(value)
    @value = value
  end
end
