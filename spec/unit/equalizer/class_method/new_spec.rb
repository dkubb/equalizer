# encoding: utf-8

require 'spec_helper'

describe Equalizer, '.new' do

  let(:object) { described_class }
  let(:name)   { 'User'          }
  let(:klass)  { ::Class.new     }

  context 'with no keys' do
    subject { object.new }

    before do
      # specify the class #name method
      klass.stub(:name).and_return(name)
      klass.send(:include, subject)
    end

    let(:instance) { klass.new }

    it { should be_instance_of(object) }

    it { should be_frozen }

    it 'defines #hash and #inspect methods dynamically' do
      subject.public_instance_methods(false).map(&:to_s).should =~ %w[ hash inspect ]
    end

    describe '#eql?' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { instance.eql?(other).should be(true) }
      end

      context 'when the objects are different' do
        let(:other) { stub('other') }

        it { instance.eql?(other).should be(false) }
      end
    end

    describe '#==' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { (instance == other).should be(true) }
      end

      context 'when the objects are different' do
        let(:other) { stub('other') }

        it { (instance == other).should be(false) }
      end
    end

    describe '#hash' do
      it 'has the expected arity' do
        klass.instance_method(:hash).arity.should be(0)
      end

      it { instance.hash.should eql(klass.hash) }
    end

    describe '#inspect' do
      it 'has the expected arity' do
        klass.instance_method(:inspect).arity.should be(0)
      end

      it { instance.inspect.should eql('#<User>') }
    end
  end

  context 'with keys' do
    subject { object.new(*keys) }

    let(:keys)       { [ :firstname, :lastname ].freeze }
    let(:firstname)  { 'John'                           }
    let(:lastname)   { 'Doe'                            }
    let(:instance)   { klass.new(firstname, lastname)   }

    let(:klass) do
      ::Class.new do
        attr_reader :firstname, :lastname

        def initialize(firstname, lastname)
          @firstname, @lastname = firstname, lastname
        end
      end
    end

    before do
      # specify the class #inspect method
      klass.stub(:name).and_return(nil)
      klass.stub(:inspect).and_return(name)
      klass.send(:include, subject)
    end

    it { should be_instance_of(object) }

    it { should be_frozen }

    it 'defines #hash and #inspect methods dynamically' do
      subject.public_instance_methods(false).map(&:to_s).should =~ %w[ hash inspect ]
    end

    describe '#eql?' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { instance.eql?(other).should be(true) }
      end

      context 'when the objects are different' do
        let(:other) { stub('other') }

        it { instance.eql?(other).should be(false) }
      end
    end

    describe '#==' do
      context 'when the objects are similar' do
        let(:other) { instance.dup }

        it { (instance == other).should be(true) }
      end

      context 'when the objects are different type' do
        let(:other) { klass.new('Foo', 'Bar') }

        it { (instance == other).should be(false) }
      end

      context 'when the objects are from different type' do
        let(:other) { stub('other') }

        it { (instance == other).should be(false) }
      end
    end

    describe '#hash' do
      it { instance.hash.should eql(klass.hash ^ firstname.hash ^ lastname.hash) }
    end

    describe '#inspect' do
      it { instance.inspect.should eql('#<User firstname="John" lastname="Doe">') }
    end
  end
end
