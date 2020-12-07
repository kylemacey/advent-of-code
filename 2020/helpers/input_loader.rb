require "uri"
require "net/http"
require "date"

module InputLoader
  module_function
  def get_most_recent_input
    day_0 = Date.parse("2020-11-30")
    today = (Date.today - day_0).to_i
    puts today
    get_input(today)
  end

  module_function
  def get_input(day)
    uri = URI("https://adventofcode.com/2020/day/#{day}/input")
    req = Net::HTTP::Get.new(uri)
    req["cookie"] = cookie
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
      http.request(req)
    }
    res.body
  end

  def cookie
    File.read(".cookie")
  end
end
