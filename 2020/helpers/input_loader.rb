require "uri"
require "net/http"
require "date"

module InputLoader
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

include InputLoader
