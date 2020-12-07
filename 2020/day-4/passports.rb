require_relative "../helpers/input_loader"


input = InputLoader.get_input(4)

# input = <<~INPUT
# eyr:1972 cid:100
# hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

# iyr:2019
# hcl:#602927 eyr:1967 hgt:170cm
# ecl:grn pid:012533040 byr:1946

# hcl:dab227 iyr:2012
# ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

# hgt:59cm ecl:zzz
# eyr:2038 hcl:74454a iyr:2023
# pid:3556412378 byr:2007
# INPUT

# require "pry"; binding.pry
passports = input.split(/\n\n/)
valid = 0
req = %w(byr iyr eyr hgt hcl ecl pid)
ecls = %w(amb blu brn gry grn hzl oth)
passports.each do |p|
  matches = p.scan(/(\w+):(\S+)/).to_h
  require "pry"
  next unless req.all? { |r| matches.keys.include?(r) }
  next unless (1920..2002).include?(matches["byr"].to_i)
  next unless (2010..2020).include?(matches["iyr"].to_i)
  next unless (2020..2030).include?(matches["eyr"].to_i)
  if height_match = matches["hgt"].match(/(\d+)cm/)
    next unless (150..193).include?(height_match[1].to_i)
  elsif height_match = matches["hgt"].match(/(\d+)in/)
    next unless (59..76).include?(height_match[1].to_i)
  else
    next
  end
  next unless matches["hcl"].match?(/^#[\da-f]{6}$/)
  next unless ecls.include?(matches["ecl"])
  next unless matches["pid"].match?(/^\d{9}$/)
  puts "valid"
  valid += 1
end

puts valid
