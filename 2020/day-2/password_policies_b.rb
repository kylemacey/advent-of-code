class Password < String
  def values_at_index_1(...)
    chars.unshift("💩").values_at(...)
  end
end

class Policy
  attr_reader :positions, :character

  def initialize(positions, character)
    @positions = positions
    @character = character
  end

  def validate(password)
    chars = password.values_at_index_1(*positions)
    chars.count(character) == 1
  end
end

class PasswordPolicy
  REGEX = /(?<first_position>\d+)-(?<second_position>\d+) (?<character>\w+): (?<password>.+)/

  attr_reader :policy, :password

  def self.from_str(str)
    matches = str.match(REGEX)
    positions = [matches[:first_position].to_i, matches[:second_position].to_i]
    policy = Policy.new(positions, matches[:character])
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
refute PasswordPolicy.from_str("2-9 c: ccccccccc").valid?


# Solution

password_policies = File.readlines("password_policies_input.txt").map do |line|
  PasswordPolicy.from_str(line)
end

puts password_policies.count(&:valid?)