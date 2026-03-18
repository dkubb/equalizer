# frozen_string_literal: true

require "test_helper"

class DeconstructTest < EqualizerTestCase
  def test_deconstruct
    assert_equal [1, 2], Point.new(1, 2).deconstruct

    case Point.new(3, 4)
    in [x, y] then assert_equal 7, x + y
    end
  end

  def test_deconstruct_keys_with_nil
    point = Point.new(1, 2, "label")

    assert_equal({x: 1, y: 2}, point.deconstruct_keys(nil))
  end

  def test_deconstruct_keys_with_subset
    point = Point.new(1, 2, "label")

    assert_equal({x: 1}, point.deconstruct_keys([:x]))
    assert_equal({x: 1}, point.deconstruct_keys(%i[x unknown]))
    assert_empty point.deconstruct_keys([:unknown])
  end

  def test_deconstruct_keys_pattern_matching
    case Point.new(3, 4)
    in {x:, y:} then assert_equal 12, x * y
    end
  end

  def test_deconstruct_returns_values_in_order
    klass = Class.new do
      include Equalizer.new(:a, :b, :c)

      attr_reader :a, :b, :c
      def initialize(a, b, c) = (@a, @b, @c = a, b, c)
    end

    assert_equal [1, 2, 3], klass.new(1, 2, 3).deconstruct
  end

  def test_deconstruct_keys_returns_all_keys_for_nil
    klass = Class.new do
      include Equalizer.new(:a, :b)

      attr_reader :a, :b
      def initialize(a, b) = (@a, @b = a, b)
    end

    assert_equal({a: 1, b: 2}, klass.new(1, 2).deconstruct_keys(nil))
  end

  def test_deconstruct_keys_returns_only_requested_keys
    klass = Class.new do
      include Equalizer.new(:a, :b)

      attr_reader :a, :b
      def initialize(a, b) = (@a, @b = a, b)
    end

    obj = klass.new(1, 2)

    assert_equal({a: 1}, obj.deconstruct_keys([:a]))
    assert_equal({b: 2}, obj.deconstruct_keys([:b]))
    assert_empty obj.deconstruct_keys([:unknown])
  end
end
