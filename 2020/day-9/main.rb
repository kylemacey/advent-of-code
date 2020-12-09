# Day 9

require_relative "../helpers.rb"

# Use for testing
input = <<-IN
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
IN

input = get_input(9)

input = input.each_line.to_a.map(&:to_i)


bad = 0
input.each.with_index do |i, n|
  next unless n > 24
  preamble = input[n-25, 25]
  good = false
  preamble.each do |p|
    diff = i - p
    if preamble.include?(diff) && diff != p
      good = true
      break
    end
  end
  next if good
  bad = i
  break
end

puts bad

