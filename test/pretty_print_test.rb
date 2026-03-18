# frozen_string_literal: true

require "test_helper"

class PrettyPrintTest < EqualizerTestCase
  def test_pretty_print_instance_variables
    point = Point.new(1, 2, "label")

    assert_equal %i[@x @y], point.pretty_print_instance_variables
    refute_includes point.pretty_print_instance_variables, :@label
  end

  def test_pretty_print
    require "pp"

    result = PP.pp(Point.new(1, 2, "label"), +"")

    assert_match(/\A#<Point:0x[0-9a-f]+\s+@x=1,\s+@y=2>\n\z/m, result)
    refute_match(/@label/, result)
  end

  def test_pretty_print_shows_equalizer_attributes
    require "pp"
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x, :other
      def initialize(x, other) = (@x, @other = x, other)
    end

    result = PP.pp(klass.new(42, "hidden"), +"")

    assert_match(/\A#<.*:0x[0-9a-f]+\s+@x=42>\n\z/, result)
    refute_match(/@other/, result)
  end

  def test_pretty_print_calls_pp_object
    require "pp"
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    obj = klass.new(1)
    result = PP.pp(obj, +"")

    assert_match(/\A#</, result)
  end

  def test_pretty_print_method_exists
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    obj = klass.new(1)

    assert_respond_to obj, :pretty_print
    assert_equal 1, obj.method(:pretty_print).arity
  end

  def test_pretty_print_uses_pp_object
    require "pp"

    called = false
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x

      define_method(:pretty_print_instance_variables) do
        called = true
        %i[@x]
      end
    end

    PP.pp(klass.new(1), +"")

    assert called,
      "pretty_print should use pp_object " \
      "which calls pretty_print_instance_variables"
  end

  def test_inspect_false_does_not_override_pretty_print
    require "pp"
    klass = Class.new do
      include Equalizer.new(:id, inspect: false)

      attr_reader :id, :name
      def initialize(id, name) = (@id, @name = id, name)
    end

    obj = klass.new(1, "Amy")

    refute_includes obj.class.ancestors, Equalizer::InspectMethods
  end

  def test_inspect_false_preserves_struct_pretty_print
    require "pp"
    klass = Class.new(Struct.new(:id, :name)) do
      include Equalizer.new(:id, inspect: false)
    end

    result = PP.pp(klass.new(1, "Amy"), +"")

    assert_match(/id=1/, result)
    assert_match(/name="Amy"/, result)
  end
end
