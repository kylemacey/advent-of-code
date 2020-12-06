input = <<-IN
abc

a
b
c

ab
ac

a
a
a
a

b
IN

input = File.read("./input.txt")

groups = input.split("\n\n")

total = groups.map do |g|
    g.split("\n").map(&:chars).inject(:&).length
end.inject(:+)

puts total
