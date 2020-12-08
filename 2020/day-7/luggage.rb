require_relative "../helpers.rb"

input = <<-IN
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 1 dark violet bag.
dark violet bags contain no other bags.
IN

input = get_input(7)

lines = C(input)
  .single(/^(\w+ \w+)/, container: String)
  .repeating(:containees, /(\d+) (\w+ \w+)/, qty: Integer, desc: String)
  .combination

new_containees = [{desc: "shiny gold", qty: 1}]
total = 0

# [{"dark red" => 2}]
loop do
  new_containees = lines.map do |line|
    next unless parent_containee = new_containees.detect { |nc| nc[:desc] == line[:container] }
    line[:containees].map do |containee|
      new_qty = parent_containee[:qty] * containee[:qty]
      puts "adding #{new_qty} #{containee[:desc]} bags, #{containee[:qty]} in each of the #{parent_containee[:qty]} #{parent_containee[:desc]} bags"
      total += new_qty
      { desc: containee[:desc], qty: new_qty }
    end
  end.flatten.compact
    # Sum any qty by duplicate desc
    .group_by { |x| x[:desc] }.map {|desc, attrs| { desc: desc, qty: attrs.sum { |x| x[:qty] } } }
  puts
  break if new_containees.empty?
end

puts(total)