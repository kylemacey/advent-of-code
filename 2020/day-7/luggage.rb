input = <<-IN
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 1 dark violet bag.
dark violet bags contain no other bags.
IN

require_relative "../helpers/input_loader"


input = InputLoader.get_input(7)

container_regex = /(\w+ \w+) bags contain/
containee_regex = /(\d+) (\w+ \w+) bag/
containers = input.each_line.map do |l|
  container = l.scan(container_regex).flatten.first
  containees = l.scan(containee_regex).map {|k,v| [v, k.to_i]}.to_h
  [container, containees]
end.to_h

# possible_containers = []
new_containees = {"shiny gold" => 1}
total = 0

# [{"dark red" => 2}]

# require "pry"; binding.pry
loop do
  new_containees = containers.map do |k, v|
    next unless new_containees[k]
    v.map do |desc, qty|
      puts "adding #{new_containees[k] * qty} #{desc} bags, #{qty} in each of the #{new_containees[k]} #{k} bags"
      total += new_containees[k] * qty
      [desc, new_containees[k] * qty]
    end.to_h
  end.compact.reduce({}) { |sums, e|  sums.merge(e) { |_, a, b| a+b } }
  # require "pry"; binding.pry
  puts
  break if new_containees.empty?
end

puts(total)