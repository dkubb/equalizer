# Define equality, equivalence and inspection methods
class Equalizer < Module
  # Initialize an Equalizer with the given keys
  #
  # Will use the keys with which it is initialized to define #cmp?,
  # #hash, and #inspect
  #
  # @param [Array<Symbol>] keys
  # @param define_inspect [Boolean] whether to override #inspect
  #
  # @return [undefined]
  #
  # @api private
  def initialize(*keys, define_inspect: true)
    @keys = keys
    define_cmp_and_hash_methods
    define_inspect_method if define_inspect
    freeze
  end

  private

  # Hook called when module is included
  #
  # @param [Module] descendant
  #   the module or class including Equalizer
  #
  # @return [self]
  #
  # @api private
  def included(descendant)
    super
    descendant.include Methods
  end

  # Define the equalizer methods based on #keys
  #
  # @return [undefined]
  #
  # @api private
  def define_cmp_and_hash_methods
    define_cmp_method
    define_hash_method
  end

  # Define an #cmp? method based on the instance's values identified by #keys
  #
  # @return [undefined]
  #
  # @api private
  def define_cmp_method
    keys = @keys
    define_method(:cmp?) do |comparator, other|
      keys.all? do |key|
        __send__(key).public_send(comparator, other.__send__(key))
      end
    end
    private :cmp?
  end

  # Define a #hash method based on the instance's values identified by #keys
  #
  # @return [undefined]
  #
  # @api private
  def define_hash_method
    keys = @keys
    define_method(:hash) do
      keys.map(&public_method(:send)).push(self.class).hash
    end
  end

  # Define an inspect method that reports the values of the instance's keys
  #
  # @return [undefined]
  #
  # @api private
  def define_inspect_method
    keys = @keys
    define_method(:inspect) do
      klass = self.class
      name = klass.name || klass.inspect
      "#<#{name}#{keys.map { |key| " #{key}=#{__send__(key).inspect}" }.join}>"
    end
  end

  # The comparison methods
  module Methods
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
      other.is_a?(self.class) && cmp?(__method__, other)
    end
  end
end
