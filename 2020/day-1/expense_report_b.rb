vals = File.readlines("./expense_report_input.txt").map(&:to_i)

diffs = vals.map do |val|
  [val, 2020-val]
end.to_h

@result = nil

diffs.each do |k, diff|
  vals.each do |val|
    if vals.include?(diff - val)
      @result = [k, val, diff-val]
      break
    end
  end
end

puts @result.inject(:*)
