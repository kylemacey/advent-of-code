class Password < String
  def instances_of(character)
    scan(character).length
  end
end

class Policy
  attr_reader :range, :character

  def initialize(range, character)
    @range = range
    @character = character
  end

  def validate(password)
    range.include?(password.instances_of(character))
  end
end

class PasswordPolicy
  REGEX = /(?<range_min>\d+)-(?<range_max>\d+) (?<character>\w+): (?<password>.+)/

  attr_reader :policy, :password

  def self.from_str(str)
    matches = str.match(REGEX)
    range = Range.new(matches[:range_min].to_i, matches[:range_max].to_i)
    policy = Policy.new(range, matches[:character])
    password = Password.new(matches[:password])
    self.new(policy, password)
  end

  def initialize(policy, password)
    @policy = policy
    @password = password
  end

  def valid?
    policy.validate(password)
  end
end

# test

def assert(condition)
  return if condition
  raise "Expected true but got false at #{caller[0]}"
end

def refute(condition)
  return unless condition
  raise "Expected false but got true at #{caller[0]}"
end


assert PasswordPolicy.from_str("1-3 a: abcde").valid?
refute PasswordPolicy.from_str("1-3 b: cdefg").valid?
assert PasswordPolicy.from_str("2-9 c: ccccccccc").valid?


# Solution

password_policies = File.readlines("password_policies_input.txt").map do |line|
  PasswordPolicy.from_str(line)
end

puts password_policies.count(&:valid?)