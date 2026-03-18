# frozen_string_literal: true

# Equalizer provides equality, equivalence, hashing, pattern matching, and
# inspection methods for Ruby objects based on specified attributes.
#
# @example Basic usage
#   class GeoLocation
#     include Equalizer.new(:latitude, :longitude)
#
#     attr_reader :latitude, :longitude, :name
#
#     def initialize(latitude, longitude, name = nil)
#       @latitude = latitude
#       @longitude = longitude
#       @name = name
#     end
#   end
#
#   loc1 = GeoLocation.new(1.0, 2.0, "Home")
#   loc2 = GeoLocation.new(1.0, 2.0, "Work")
#   loc1 == loc2  # => true (name is not part of equality)
#
# @example Pattern matching
#   case location
#   in GeoLocation(latitude:, longitude:) then "#{latitude}, #{longitude}"
#   in [lat, lon]                         then "coords: #{lat}, #{lon}"
#   end
#
# @api public
module Equalizer
  # The current version of the Equalizer gem
  VERSION = "1.0.0"

  # Creates a module providing equality methods based on the given attributes
  #
  # @example Basic usage
  #   class Point
  #     include Equalizer.new(:x, :y)
  #     attr_reader :x, :y
  #   end
  #
  # @param keys [Array<Symbol>] attribute names to use for equality
  # @return [Module] a module to include in your class
  # @raise [ArgumentError] if keys is empty or contains non-Symbols
  #
  # @api public
  def self.new(*keys)
    validate_keys!(keys)
    build_module(keys.freeze)
  end

  # Validates that keys are non-empty and all Symbols
  #
  # @param keys [Array<Object>] the keys to validate
  # @return [void]
  # @raise [ArgumentError] if keys is empty or contains non-Symbols
  #
  # @api private
  def self.validate_keys!(keys)
    raise ArgumentError, "at least one attribute is required" if keys.empty?

    invalid_types = keys.grep_v(Symbol).map(&:class).uniq
    return if invalid_types.empty?

    raise ArgumentError,
      "attribute must be a Symbol, got #{invalid_types.join(", ")}"
  end
  private_class_method :validate_keys!

  # Instance methods mixed into classes that include an Equalizer module
  #
  # @api private
  module InstanceMethods
    # Equality comparison allowing subclasses
    #
    # @param other [Object] object to compare
    # @return [Boolean] true if other is_a? same class with equal attributes
    def ==(other)
      other.is_a?(self.class) &&
        cmp?(:==, other)
    end

    # Strict equality requiring exact class match
    #
    # @param other [Object] object to compare
    # @return [Boolean] true if other is exact same class with eql? attributes
    def eql?(other)
      other.instance_of?(self.class) &&
        cmp?(:eql?, other)
    end

    # Hash code based on class and attribute values
    #
    # @return [Integer] hash code
    def hash
      [self.class, *deconstruct].hash
    end

    # Array deconstruction for pattern matching
    #
    # @return [Array] attribute values in order
    def deconstruct
      equalizer_keys.map { |key| public_send(key) }
    end

    # Hash deconstruction for pattern matching
    #
    # @param requested [Array<Symbol>, nil] keys to include, or nil for all
    # @return [Hash{Symbol => Object}] requested attribute key-value pairs
    def deconstruct_keys(requested)
      subset = requested.nil? ? equalizer_keys : equalizer_keys & requested
      subset.to_h { |key| [key, public_send(key)] }
    end

    # String representation showing only equalizer attributes
    #
    # @return [String] inspect output
    def inspect
      attrs = equalizer_keys
        .map { |key| "@#{key}=#{public_send(key).inspect}" }
        .join(", ")
      Object.instance_method(:to_s).bind_call(self).sub(/>\z/, " #{attrs}>")
    end

    # Pretty print output using PP's object formatting
    #
    # @param q [PP] pretty printer
    # @return [void]
    def pretty_print(q)
      q.pp_object(self)
    end

    # Instance variables to display in pretty print output
    #
    # @return [Array<Symbol>] instance variable names
    def pretty_print_instance_variables
      equalizer_keys.map { |key| :"@#{key}" }
    end

    private

    # Compare all attributes using the given comparator
    #
    # @param comparator [Symbol] method to use for comparison
    # @param other [Object] object to compare against
    # @return [Boolean] true if all attributes match
    #
    # @api private
    def cmp?(comparator, other)
      equalizer_keys.all? do |key|
        public_send(key)
          .public_send(comparator, other.public_send(key))
      end
    end
  end

  # Builds the module with equality methods for the given keys
  #
  # @param keys [Array<Symbol>] attribute names (frozen)
  # @return [Module] the configured module
  #
  # @api private
  def self.build_module(keys)
    Module.new do
      include InstanceMethods

      set_temporary_name("Equalizer(#{keys.join(", ")})")

      define_method(:equalizer_keys) { keys }
      private :equalizer_keys
    end
  end
  private_class_method :build_module
end
