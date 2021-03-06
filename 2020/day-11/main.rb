# Day 11

require_relative "../helpers.rb"

# Use for testing
input = <<-IN
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
IN

input = get_input(11)

# C(input)
#   .single(/^(w+ w+)/, :container)
#   .repeating(:containees, /(d+) (w+ w+)/, :qty, :desc)
#   .combination.to_a

class Seat
  attr_reader :row, :column, :occupied

  def initialize(row, column, occupied)
    @row, @column, @occupied = row, column, occupied
  end

  def occupied?
    !!occupied
  end

  def render
    occupied? ? "#" : "L"
  end

  def neighbors(floorplan)
    rowspan = row == 0 ? (0..1) : (row - 1)..(row + 1)
    colspan = column == 0 ? (0..1) : (column - 1)..(column + 1)

    floorplan[rowspan].flat_map do |row|
      row[colspan].select { |i| i.is_a?(Seat) && i != self }
    end.compact
  end

  def should_occupy?(floorplan)
    if occupied?
      !(neighbors(floorplan).select(&:occupied?).length >= 4)
    else
      neighbors(floorplan).none?(&:occupied?)
    end
  end
end

class Floor
  attr_reader :row, :column

  def initialize(row, column)
    @row, @column = row, column
  end

  def render
    "."
  end

  def occupied?
    false
  end
end

floorplan = input.each_line.map.with_index do |line, row|
  line.chars.map.with_index do |char, column|
    case char
    when "."
      Floor.new(row, column)
    when "L"
      Seat.new(row, column, false)
    when "#"
      Seat.new(row, column, true)
    end
  end.compact
end


def render(floorplan)
  floorplan.each do |row|
    puts row.map(&:render).join
  end
  puts
end

def iterate(floorplan)
  floorplan.map do |row|
    row.map do |item|
      next item if item.is_a?(Floor)
      Seat.new(item.row, item.column, item.should_occupy?(floorplan))
    end
  end
end

def compare(floorplan_1, floorplan_2)
  floorplan_1.flatten.map(&:render).join == floorplan_2.flatten.map(&:render).join
end

final_floorplan = nil

loop do
  previous_floorplan = floorplan
  floorplan = iterate(previous_floorplan)
  render floorplan
  if compare(previous_floorplan, floorplan)
    final_floorplan = floorplan
    break
  end
end

puts final_floorplan.flatten.select(&:occupied?).length
