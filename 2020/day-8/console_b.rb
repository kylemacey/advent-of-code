input = <<-IN
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
IN

require_relative "../helpers/input_loader"


input = InputLoader.get_input(8)

class Dsl
  attr_accessor :accumulator, :index, :ran, :change_index
  attr_reader :input, :change

  def initialize(input, change, accumulator = 0)
    @input = input.lines
    @accumulator = accumulator
    @index = 0
    @ran = []
    @change = change
    @change_index = 0
  end

  def acc(num)
    self.accumulator += num.to_i
    self.index += 1
  end

  def jmp(num)
    self.change_index += 1
    return nop(num) if should_change?
    self.index += num.to_i
  end

  def nop(num)
    self.change_index += 1
    return jmp(num) if should_change?
    self.index += 1
  end

  def completed?
    index == input.length
  end

  def should_change?
    change_index == change
  end

  def go!
    loop do
      # normal end
      break if completed?

      # infinite loop
      break if ran.include?(self.index)
      ran.push(self.index)

      line = input[self.index]
      method, arg = line.scan(/(\w{3}) ([-+]\d+)/).flatten
      # require "pry"; binding.pry
      self.send(method, arg)
    end

    completed? ? accumulator : false
  end
end

i = 0
loop do
  if out = Dsl.new(input, i).go!
    puts out
    break
  end
  i += 1
end