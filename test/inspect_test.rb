# frozen_string_literal: true

require "test_helper"

class InspectTest < EqualizerTestCase
  def test_inspect
    result = Point.new(1, 2, "label").inspect

    assert_match(/\A#<Point:0x[0-9a-f]+ @x=1, @y=2>\z/, result)
    refute_match(/@label/, result)
  end

  def test_inspect_shows_equalizer_attributes
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x, :other
      def initialize(x, other) = (@x, @other = x, other)
    end

    result = klass.new(42, "hidden").inspect

    assert_match(/\A#<.*:0x[0-9a-f]+\s+@x=42>\z/, result)
    refute_match(/@other/, result)
  end

  def test_inspect_formats_multiple_attributes
    klass = Class.new do
      include Equalizer.new(:a, :b)

      attr_reader :a, :b
      def initialize(a, b) = (@a, @b = a, b)
    end

    result = klass.new(1, 2).inspect

    assert_match(/@a=1, @b=2/, result)
  end

  def test_inspect_calls_inspect_on_values
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    result = klass.new("hello").inspect

    assert_match(/@x="hello"/, result)
  end

  def test_inspect_uses_self_not_nil
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    result = klass.new(1).inspect

    refute_match(/NilClass/, result)
    assert_match(/\A#</, result)
  end

  def test_inspect_substitutes_at_end_of_string
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    result = klass.new(1).inspect

    assert_match(/>\z/, result)
    assert_match(/@x=1>\z/, result)
  end

  def test_inspect_returns_object_format
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    result = klass.new(1).inspect

    assert_match(/\A#<.+:0x[0-9a-f]+ @x=1>\z/, result)
  end

  def test_inspect_has_arity_zero
    assert_equal 0, Point.instance_method(:inspect).arity
  end

  def test_inspect_includes_class_name
    result = Point.new(1, 2).inspect

    assert_match(/\A#<Point:/, result)
  end

  def test_inspect_false_does_not_override_inspect
    klass = Class.new do
      include Equalizer.new(:id, inspect: false)

      attr_reader :id, :name
      def initialize(id, name) = (@id, @name = id, name)
    end

    result = klass.new(1, "Amy").inspect

    refute_match(/\A#<.*@id=1>\z/, result)
  end

  def test_inspect_false_preserves_struct_inspect
    klass = Class.new(Struct.new(:id, :name)) do
      include Equalizer.new(:id, inspect: false)
    end

    result = klass.new(1, "Amy").inspect

    assert_match(/id=1/, result)
    assert_match(/name="Amy"/, result)
  end

  def test_inspect_true_overrides_inspect
    klass = Class.new do
      include Equalizer.new(:id, inspect: true)

      attr_reader :id, :name
      def initialize(id, name) = (@id, @name = id, name)
    end

    result = klass.new(1, "Amy").inspect

    assert_match(/@id=1/, result)
    refute_match(/@name/, result)
  end
end
