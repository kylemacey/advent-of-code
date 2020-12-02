vals = File.readlines("./expense_report_input.txt").map(&:to_i)

val_a = vals.detect do |val|
  vals.include?(2020-val)
end

puts val_a * (2020-val_a)
