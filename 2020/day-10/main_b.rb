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

input = <<-IN
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
IN

input = get_input(10)

# C(input)
#   .single(/^(w+ w+)/, :container)
#   .repeating(:containees, /(d+) (w+ w+)/, :qty, :desc)
#   .combination.to_a
# puts; puts
input = input.each_line.map(&:to_i).sort.unshift(0)
input += [input.max + 3]

chunks = input.chunk.with_index { |e, i| input[i+1].to_i - e == 3 }
guide = {
  2 => 2,
  3 => 4,
  4 => 7,
  5 => 24,
}

idkwtf = chunks.map do |anchor, arr|
  next if anchor
  guide[arr.length]
end.compact

p idkwtf.inject(:*)