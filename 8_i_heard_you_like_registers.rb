# takes a source, reports the biggest register value at the end or runtime peak
class Program
  def initialize(source)
    @source = source
  end

  def end_max
    context = Context.new
    @source.lines.map(&context.method(:max_after)).last
  end

  def peak_max
    context = Context.new
    @source.lines.map(&context.method(:max_after)).max
  end
end

# a clean-room context that can report the max register value after every line
class Context
  def initialize
    @room = Class.new(BasicObject) do
      def binding
        Kernel.binding
      end
    end.new.binding
  end

  # we could use a proper parser, but if we squint the source is almost-Ruby… 😈
  def max_after(line)
    line.split.values_at(0, 4).each(&method(:ensure_register_exists))
    room.eval line.split(' ', 2).join('.')
    room.local_variables.map(&room.method(:local_variable_get)).map(&:value).max
  end

  private

  attr_reader :room

  def ensure_register_exists(name)
    return if room.local_variable_defined?(name)
    room.local_variable_set(name, Reg.new)
  end
end

# a zero-initialised register with dec and inc methods, comparable to an integer
class Reg
  include Comparable

  def initialize
    @value = 0
  end

  def <=>(integer)
    @value <=> integer
  end

  def dec(decrement)
    @value -= decrement
  end

  def inc(increment)
    @value += increment
  end

  attr_reader :value
end

require 'minitest/autorun'
require 'minitest/pride'

describe Program do
  let(:source) do
    <<~SOURCE
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
    SOURCE
  end

  describe '#end_max' do
    it 'returns the value of the largest register after the run' do
      _(Program.new(source).end_max).must_equal 1
    end
  end

  describe '#peak_max' do
    it 'returns the highest value of a register anytime' do
      _(Program.new(source).peak_max).must_equal 10
    end
  end
end
