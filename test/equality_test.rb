# frozen_string_literal: true

require "test_helper"

class EqualityTest < EqualizerTestCase
  def test_equality_with_equal_attributes
    assert_equal Point.new(1, 2), Point.new(1, 2)
    assert_equal Point.new(1, 2, "a"), Point.new(1, 2, "b")
  end

  def test_equality_with_different_attributes
    refute_equal Point.new(1, 2), Point.new(9, 2)
    refute_equal Point.new(1, 2), Point.new(1, 9)
  end

  def test_equality_parent_matches_subclass
    assert_equal Point.new(1, 2), ColoredPoint.new(1, 2, "red")
    refute_equal ColoredPoint.new(1, 2, "red"), Point.new(1, 2)
  end

  def test_equality_with_non_equalizer_objects
    refute_equal Point.new(1, 2), "string"
    refute_equal Point.new(1, 2), nil
  end

  def test_equality_delegates_to_attributes
    tracker = Class.new do
      attr_reader :compared_with
      def ==(_other) = (@compared_with = :==) || true
    end

    wrapper = Class.new do
      include Equalizer.new(:value)

      attr_reader :value
      def initialize(value) = @value = value
    end

    t = tracker.new

    assert_equal wrapper.new(t), wrapper.new(tracker.new)
    assert_equal :==, t.compared_with
  end

  def test_eql_delegates_to_attributes
    tracker = Class.new do
      attr_reader :compared_with
      def eql?(_other) = (@compared_with = :eql?) || true
    end

    wrapper = Class.new do
      include Equalizer.new(:value)

      attr_reader :value
      def initialize(value) = @value = value
    end

    t = tracker.new

    assert wrapper.new(t).eql?(wrapper.new(tracker.new))
    assert_equal :eql?, t.compared_with
  end

  def test_equality_requires_type_check
    klass = Class.new do
      include Equalizer.new(:x, :y)

      attr_reader :x, :y
      def initialize(x, y) = (@x, @y = x, y)
    end

    duck = Class.new do
      attr_reader :x, :y
      def initialize(x, y) = (@x, @y = x, y)
    end

    refute_equal klass.new(1, 2), duck.new(1, 2)
  end

  def test_equality_checks_all_attributes
    klass = Class.new do
      include Equalizer.new(:a, :b)

      attr_reader :a, :b
      def initialize(a, b) = (@a, @b = a, b)
    end

    refute_equal klass.new(1, 2), klass.new(1, 99)
    refute_equal klass.new(1, 2), klass.new(99, 2)
  end

  def test_equality_with_same_object
    point = Point.new(1, 2)
    same = point

    assert_equal same, point
  end

  def test_equality_is_symmetric_when_equal
    a = Point.new(1, 2)
    b = Point.new(1, 2)

    assert_equal a, b
    assert_equal b, a
  end

  def test_equality_is_symmetric_when_not_equal
    a = Point.new(1, 2)
    b = Point.new(9, 9)

    refute_equal a, b
    refute_equal b, a
  end

  def test_equality_is_symmetric_with_other_class
    klass = Class.new do
      include Equalizer.new(:x, :y)

      attr_reader :x, :y
      def initialize(x, y) = (@x, @y = x, y)
    end

    duck = Class.new do
      attr_reader :x, :y
      def initialize(x, y) = (@x, @y = x, y)
    end

    refute_equal klass.new(1, 2), duck.new(1, 2)
    refute_equal duck.new(1, 2), klass.new(1, 2)
  end

  def test_equality_allows_subclasses
    parent = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end
    child = Class.new(parent)

    assert_equal parent.new(1), child.new(1)
    refute_equal child.new(1), parent.new(1)
  end
end
