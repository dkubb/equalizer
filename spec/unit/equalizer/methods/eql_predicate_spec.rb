require 'spec_helper'

describe Equalizer::Methods, '#eql?' do
  subject { object.eql?(other) }

  let(:object) { described_class.new(true) }

  let(:described_class) do
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
      expect(subject).to eql(other.eql?(object))
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { is_expected.to be(true) }

    it 'is symmetric' do
      expect(subject).to eql(other.eql?(object))
    end
  end

  context 'with an equivalent object of a subclass' do
    let(:other) { Class.new(described_class).new(true) }

    it { is_expected.to be(false) }

    it 'is symmetric' do
      expect(subject).to eql(other.eql?(object))
    end
  end

  context 'with a different object' do
    let(:other) { described_class.new(false) }

    it { is_expected.to be(false) }

    it 'is symmetric' do
      expect(subject).to eql(other.eql?(object))
    end
  end
end
