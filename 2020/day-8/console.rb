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
  attr_accessor :accumulator, :index, :ran
  attr_reader :input

  def initialize(input, accumulator = 0)
    @input = input.lines
    @accumulator = accumulator
    @index = 0
    @ran = []
  end

  def acc(num)
    puts "acc #{num}"
    self.accumulator += num.to_i
    self.index += 1
  end

  def jmp(num)
    puts "jmp #{num}"
    self.index += num.to_i
  end

  def nop(_)
    self.index += 1
  end

  def go!
    loop do
      break if ran.include?(self.index)
      ran.push(self.index)
      line = input[self.index]
      method, arg = line.scan(/(\w{3}) ([-+]\d+)/).flatten
      # require "pry"; binding.pry
      self.send(method, arg)
    end

    puts accumulator
  end
end

Dsl.new(input).go!