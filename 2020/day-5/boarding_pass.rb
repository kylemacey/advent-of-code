# input = <<-IN
# BFFFBBFRRR
# FFFBBBFRRR
# BBFFBBFRLL
# IN

input = File.read("./input.txt")

boarding_passes = input.each_line.map do |b|
  {
    row: b[0,7],
    column: b[7,3],
  }
end

def bisect(range, lower)
  lower_bound = (range.min + range.max) / 2
  if lower
    (range.min..lower_bound)
  else
    ((lower_bound + 1)..range.max)
  end
end

seat_ids = []

boarding_passes.each do |bp|
  row_range = (0..127)
  bp[:row].chars.each do |c|
    row_range = bisect(row_range, c == "F")
  end
  # print row_range.min

  col_range = (0..7)
  bp[:column].chars.each do |c|
    col_range = bisect(col_range, c == "L")
  end
  
  # print col_range.min

  seat_id = 8 * row_range.min + col_range.min
  seat_ids << seat_id

  puts "#{row_range.min} #{col_range.min} :: #{seat_id}"
end

puts seat_ids.max

puts seat_ids.sort.join("\n")

seat_ids.sort.each_with_index do |id, i|
  next unless prev = seat_ids.sort[(i-1)]
  if id - prev != 1
    puts "#{id}/#{prev}:#{i}!!#{id - prev}"
  end   
end