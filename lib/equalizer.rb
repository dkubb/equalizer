# encoding: utf-8

# Define equality, equivalence and inspection methods
module Equalizer
  # Initialize an Equalizer with the given keys
  #
  # Will use the keys with which it is initialized to define #cmp?,
  # #hash, and #inspect
  #
  # @param [Array<Symbol>] keys
  #
  # @return [Module]
  #
  # @api public
  def self.new(*keys)
    Module.new do
      define_method(:keys) { keys }
      include Methods
    end.freeze
  end

  # The comparison methods
  module Methods
    private def cmp?(comparator, other)
      keys.all? do |key|
        __send__(key).public_send(comparator, other.__send__(key))
      end
    end

    def hash
      keys.map(&method(:send)).push(self.class).hash
    end

    def inspect
      klass = self.class
      name  = klass.name || klass.inspect
      "#<#{name}#{keys.map { |key| " #{key}=#{__send__(key).inspect}" }.join}>"
    end

    # Compare the object with other object for equality
    #
    # @example
    #   object.eql?(other)  # => true or false
    #
    # @param [Object] other
    #   the other object to compare with
    #
    # @return [Boolean]
    #
    # @api public
    def eql?(other)
      instance_of?(other.class) && cmp?(__method__, other)
    end

    # Compare the object with other object for equivalency
    #
    # @example
    #   object == other  # => true or false
    #
    # @param [Object] other
    #   the other object to compare with
    #
    # @return [Boolean]
    #
    # @api public
    def ==(other)
      other = coerce(other).first if respond_to?(:coerce, true)
      other.kind_of?(self.class) && cmp?(__method__, other)
    end
  end # module Methods
end # class Equalizer
