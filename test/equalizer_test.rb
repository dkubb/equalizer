# frozen_string_literal: true

require "test_helper"

class EqualizerTest < EqualizerTestCase
  def test_creates_module_with_descriptive_name
    mod = Equalizer.new(:foo, :bar)

    assert_kind_of Module, mod
    assert_equal "Equalizer(foo, bar)", mod.name
  end

  def test_equalizer_keys_is_private
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    obj = klass.new(1)

    assert_includes klass.private_instance_methods, :equalizer_keys
    assert_raises(NoMethodError) { obj.equalizer_keys }
  end

  def test_keys_are_frozen
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    obj = klass.new(1)
    keys = obj.send(:equalizer_keys)

    assert_predicate keys, :frozen?
    assert_raises(FrozenError) { keys << :y }
  end

  def test_raises_on_empty_keys
    error = assert_raises(ArgumentError) { Equalizer.new }

    assert_equal "at least one attribute is required", error.message
  end

  def test_raises_on_non_symbol_keys
    error = assert_raises(ArgumentError) { Equalizer.new("foo") }

    assert_equal "attribute must be a Symbol, got String", error.message
  end

  def test_uses_case_equality_for_symbol_validation
    error = assert_raises(ArgumentError) { Equalizer.new(Object.new) }

    assert_match(/attribute must be a Symbol, got Object/, error.message)
  end

  def test_reports_all_unique_invalid_types
    error = assert_raises(ArgumentError) do
      Equalizer.new("foo", 123, "bar", 4.5)
    end

    assert_equal(
      "attribute must be a Symbol, got String, Integer, Float",
      error.message
    )
  end

  def test_each_call_creates_independent_module
    mod1 = Equalizer.new(:foo)
    mod2 = Equalizer.new(:bar)

    refute_same mod1, mod2
  end

  def test_includes_instance_methods_in_descendant
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    assert_includes klass.ancestors, Equalizer::InstanceMethods
  end

  def test_descendant_responds_to_all_instance_methods
    klass = Class.new do
      include Equalizer.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    obj = klass.new(1)

    %i[== eql? hash inspect deconstruct deconstruct_keys].each do |method|
      assert_respond_to obj, method
    end
  end
end
