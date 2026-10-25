# frozen_string_literal: true

# Value objects for the benchmarks: one with a single key, and one with
# ten, more than most value objects have. Their attributes are fixed
# Integers and frozen Strings, so every iteration does the same work.

# The attribute names of the ten-key value object
MANY_KEYS = %i[a b c d e f g h i j].freeze

# A value object compared on one attribute
class OneKey
  include Equalizer.new(:id)

  attr_reader :id

  def initialize(id)
    @id = id
  end
end

# A value object compared on ten attributes
class ManyKeys
  include Equalizer.new(*MANY_KEYS)

  attr_reader(*MANY_KEYS)

  def initialize(*values)
    MANY_KEYS.zip(values) { |key, value| instance_variable_set(:"@#{key}", value) }
  end
end

# The values of a ten-key value object, half Integers and half Strings
def many_values(first = 1)
  [first, "b", 3, "d", 5, "f", 7, "h", 9, "j"]
end
