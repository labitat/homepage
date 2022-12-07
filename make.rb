require "nokogiri"
require "erb"
require "net/http"
require "icalendar"

# fetch page
# re-assemble it into template
#   <h2><span class="mw-headline"
# suck in https://labitat.dk/events.ics
#

def make_section(page, title)
  sibs = []
  el = page.at(%|h1:contains("#{title}")|)
  while el = el.next_element
    break if el.name == "h1"
    sibs << el.to_html
  end
  sibs.join("\n")
end

home_page = Nokogiri::HTML(File.read("home_page.html"))

about_section = make_section(home_page, "About")
events_section = make_section(home_page, "Events")
connect_section = make_section(home_page, "Connect")
just_visit_us_section = make_section(home_page, "Just Visit Us!")

template = ERB.new File.read("template.erb")

uri = URI("https://labitat.dk/events.ics")
calendar = Net::HTTP.get(uri)
cal = Icalendar::Calendar.parse(calendar).first
events = cal.events.first(5)
result = template.result
File.write("build/out.html", result)
