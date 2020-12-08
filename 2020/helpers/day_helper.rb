require "date"

module DayHelper
  def today
    raise "This only works in December!" unless Date.today.month == 12
    Date.today.day
  end
end
