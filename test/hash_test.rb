# frozen_string_literal: true

require "test_helper"

class HashTest < EqualizerTestCase
  def test_hash
    assert_equal Point.new(1, 2).hash, Point.new(1, 2).hash
    refute_equal Point.new(1, 2).hash, Point.new(9, 9).hash

    cache = {Point.new(1, 2) => "found"}

    assert_equal "found", cache[Point.new(1, 2)]
  end

  def test_hash_includes_class
    other = Class.new do
      include Equalizer.new(:x, :y)

      attr_reader :x, :y
      def initialize(x, y) = (@x, @y = x, y)
    end

    refute_equal Point.new(1, 2).hash, other.new(1, 2).hash
  end

  def test_hash_depends_on_class
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    assert_equal klass.new(1).hash, klass.new(1).hash

    cache = {klass.new(1) => "found"}

    assert_equal "found", cache[klass.new(1)]
  end

  def test_hash_differs_for_different_values
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    refute_equal klass.new(1).hash, klass.new(2).hash
  end

  def test_hash_differs_for_different_classes
    klass1 = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end
    klass2 = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    refute_equal klass1.new(1).hash, klass2.new(1).hash
  end

  def test_hash_uses_splatted_deconstruct
    klass = Class.new do
      include Equalizer.new(:a, :b)

      attr_reader :a, :b
      def initialize(a, b) = (@a, @b = a, b)
    end

    obj = klass.new(1, 2)
    expected = [klass, 1, 2].hash

    assert_equal expected, obj.hash
  end

  def test_hash_has_arity_zero
    assert_equal 0, Point.instance_method(:hash).arity
  end
end
