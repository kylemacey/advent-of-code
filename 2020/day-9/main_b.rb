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

prev = 25918798
# prev = 127

out = [-1]
input.each.with_index do |num, i|
  nums = []
  add = 0
  next if num == prev
  while nums.sum < prev do
    add += 1
    nums = input[i, add]
  end
  if nums.sum == prev
    out = nums
  else
    next
  end
end

p out
puts
puts out.min + out.max