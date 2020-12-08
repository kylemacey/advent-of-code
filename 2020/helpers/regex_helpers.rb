# Basically, match a regex against each line of input
class RegexLoop
  include Enumerable

  attr_reader :input, :regex

  def initialize(input, regex)
    @input = input
    @regex = regex
  end

  def each(&block)
    input.each_line do |line|
      yield(line.scan(regex))
    end
  end
end

# Will only match once against each string
class SingleMatchRegexLoop < RegexLoop
  def structure(*args)
    s = HashFactory.new(args)
    map do |x|
      s.build_hash(x.flatten)
    end
  end
end

# Can match multiple times against each string
class RepeatingMatchRegexLoop < RegexLoop
  def structure(*args)
    s = HashFactory.new(args)
    map do |x|
      x.map do |y|
        s.build_hash(y)
      end
    end
  end
end

# Similar to Struct, but makes a hash
class HashFactory
  attr_reader :keys

  def initialize(keys)
    @keys = keys
  end

  def build_hash(values)
    ensure_length!(values)
    keys.map.with_index { |e, i| [e, values[i]] }.to_h
  end

  private

  def ensure_length!(values)
    unless keys.length == values.length
      raise KeyValueLengthMismatchError.new(keys, values)
    end
  end

  class KeyValueLengthMismatchError < StandardError
    attr_reader :arr1, :arr2

    def initialize(arr1, arr2)
      @arr1, @arr2 = arr1, arr2
    end

    def message
      "Required array length of #{arr1.length} (#{arr1.inspect}) \
        but instead received #{arr2.length} (#{arr2.inspect})"
    end
  end
end

# A misnomer, since it actually combines an array of hashes, but it's pretty specific to our
# use case so ¯\_(ツ)_/¯
class RegexLoopCombination
  attr_reader :single, :repeating, :length
  include Enumerable

  def initialize(*args, **kargs)
    @single = args
    @repeating = kargs
    @length = (@single.first || @repeating.values.first).length
    ensure_length!
  end

  def each(&block)
    i = 0
    loop do
      break unless i < self.length
      h = {}
      single.map do |s|
        h.merge!(s[i])
      end
      repeating.each do |k,v|
        h.merge!({k => v[i]})
      end
      yield h
      i += 1
    end
  end

  private

  def ensure_length!
    return unless (single + repeating.keys).map(&:length).uniq.length == 1
    raise "Not all RegexLoops have the same length!"
  end
end

# A little convenience class for combining regexes and structures on a single input
class Combiner
  attr_reader :input

  attr_accessor :singles, :repeatings

  def initialize(input)
    @input = input
    @singles = []
    @repeatings = {}
  end

  def single(regex, *structure)
    singles.push(SingleMatchRegexLoop.new(input, regex).structure(*structure))
    self
  end

  def repeating(key, regex, *structure)
    repeatings[key] = RepeatingMatchRegexLoop.new(input, regex).structure(*structure)
    self
  end

  def combination
    RegexLoopCombination.new(*singles, **repeatings)
  end
end

# IDK, these felt helpful and expedient
module RegexHelpers
  def RL(...)
    RegexLoop.new(...)
  end

  def SRL(...)
    SingleMatchRegexLoop.new(...)
  end

  def RRL(...)
    RepeatingMatchRegexLoop.new(...)
  end

  def C(input)
    Combiner.new(input)
  end
end

include RegexHelpers
