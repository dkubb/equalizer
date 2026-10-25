# frozen_string_literal: true

# Equalizer's generated methods run on every comparison, Hash lookup and
# inspect of the objects that include them, so these guard each one, on
# one key and on many. Every input is built in `once`, which isn't timed.
require_relative "duel_helper"

duel "define: a class with 1 key" do
  Class.new.include(Equalizer.new(:id))
end

duel "define: a class with 10 keys" do
  Class.new.include(Equalizer.new(*MANY_KEYS))
end

duel "==: equal, 1 key" do
  once { @left, @right = OneKey.new(1), OneKey.new(1) }
  @left == @right
end

duel "==: equal, 10 keys" do
  once { @left, @right = ManyKeys.new(*many_values), ManyKeys.new(*many_values) }
  @left == @right
end

duel "==: unequal, 1 key" do
  once { @left, @right = OneKey.new(1), OneKey.new(2) }
  @left == @right
end

duel "==: unequal in the first of 10 keys" do
  once { @left, @right = ManyKeys.new(*many_values(1)), ManyKeys.new(*many_values(2)) }
  @left == @right
end

duel "==: another class, 10 keys" do
  once { @left, @right = ManyKeys.new(*many_values), Object.new }
  @left == @right
end

duel "eql?: equal, 1 key" do
  once { @left, @right = OneKey.new(1), OneKey.new(1) }
  @left.eql?(@right)
end

duel "eql?: equal, 10 keys" do
  once { @left, @right = ManyKeys.new(*many_values), ManyKeys.new(*many_values) }
  @left.eql?(@right)
end

duel "hash: 1 key" do
  once { @object = OneKey.new(1) }
  @object.hash
end

duel "hash: 10 keys" do
  once { @object = ManyKeys.new(*many_values) }
  @object.hash
end

duel "hash: look up an equal key in a Hash, 10 keys" do
  once do
    @hash = Array.new(100) { |i| [ManyKeys.new(*many_values(i)), i] }.to_h
    @key = ManyKeys.new(*many_values(50))
  end
  @hash[@key]
end

duel "inspect: 1 key" do
  once { @object = OneKey.new(1) }
  @object.inspect
end

duel "inspect: 10 keys" do
  once { @object = ManyKeys.new(*many_values) }
  @object.inspect
end

duel "match: deconstruct_keys, 2 of 10 keys" do
  once { @object = ManyKeys.new(*many_values) }
  @object.deconstruct_keys(%i[a j])
end
