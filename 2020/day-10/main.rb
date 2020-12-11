# Day 10

require_relative "../helpers.rb"

# Use for testing
input = <<-IN
16
10
15
5
1
11
7
19
6
12
4
IN

# input = get_input(10)

# C(input)
#   .single(/^(w+ w+)/, :container)
#   .repeating(:containees, /(d+) (w+ w+)/, :qty, :desc)
#   .combination.to_a

input = input.each_line.map(&:to_i).sort.unshift(0)

ones = 0
threes = 0

input.each.with_index do |e, i|
  next unless i > 0
  diff = e - input[i-1]
  puts diff
  case diff
  when 1
    ones += 1
  when 3
    threes += 1
  end
end
threes += 1

puts ones
puts threes
puts ones * threes