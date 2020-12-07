require_relative "../helpers/input_loader"


input = InputLoader.get_input(3)

# input = <<~INPUT
# ..##.......
# #...#...#..
# .#....#..#.
# ..#.#...#.#
# .#...##..#.
# ..#.##.....
# .#.#.#....#
# .#........#
# #.##...#...
# #...##....#
# .#..#...#.#
# INPUT

tree_total = 1
[
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
].each do |right, down|
  scan = 0
  trees = 0
  input.each_line.with_index do |line, i|
    next unless (i % down) == 0
    @width ||= line.length - 1
    location = line.chars[scan % @width]
    # puts "#{@width} // #{i} #{scan} #{location} [row #{i}, column #{scan % @width}]"
    if location == "#"
      trees += 1
    end
    scan += right
  end
  puts trees
  tree_total = tree_total * trees
end

puts "####{tree_total}"