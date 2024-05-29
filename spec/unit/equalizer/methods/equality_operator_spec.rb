require 'spec_helper'

describe Equalizer::Methods, '#==' do
  subject { object == other }

  let(:object)          { described_class.new(true) }
  let(:described_class) { Class.new(super_class)    }

  let(:super_class) do
    Class.new do
      include Equalizer::Methods

      attr_reader :boolean

      def initialize(boolean)
        @boolean = boolean
      end

      def cmp?(comparator, other)
        boolean.send(comparator, other.boolean)
      end
    end
  end

  context 'with the same object' do
    let(:other) { object }

    it { is_expected.to be(true) }

    it 'is symmetric' do
      is_expected.to eql(other == object)
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { is_expected.to be(true) }

    it 'is symmetric' do
      is_expected.to eql(other == object)
    end
  end

  context 'with a subclass instance having equivalent obervable state' do
    let(:other) { Class.new(described_class).new(true) }

    it { is_expected.to be(true) }

    it 'is not symmetric' do
      # the subclass instance should maintain substitutability with the object
      # (in the LSP sense) the reverse is not true.
      is_expected.to_not eql(other == object)
    end
  end

  context 'with a superclass instance having equivalent observable state' do
    let(:other) { super_class.new(true) }

    it { is_expected.to be(false) }

    it 'is not symmetric' do
      is_expected.to_not eql(other == object)
    end
  end

  context 'with an object of another class' do
    let(:other) { Class.new.new }

    it { is_expected.to be(false) }

    it 'is symmetric' do
      is_expected.to eql(other == object)
    end
  end

  context 'with an equivalent object after coercion' do
    let(:other) { Object.new }

    before do
      # declare a private #coerce method
      described_class.class_eval do
        def coerce(other)
          [self.class.new(![nil, false].include?(other)), self]
        end
        private :coerce
      end
    end

    it { is_expected.to be(true) }

    it 'is not symmetric' do
      is_expected.to_not eql(other == object)
    end
  end

  context 'with a different object after coercion' do
    let(:other) { nil }

    before do
      # declare a private #coerce method
      described_class.class_eval do
        def coerce(other)
          [self.class.new(![nil, false].include?(other)), self]
        end
        private :coerce
      end
    end

    it { is_expected.to be(false) }

    it 'is symmetric' do
      is_expected.to eql(other == object)
    end
  end

  context 'with a different object' do
    let(:other) { described_class.new(false) }

    it { is_expected.to be(false) }

    it 'is symmetric' do
      is_expected.to eql(other == object)
    end
  end
end
