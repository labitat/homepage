require "nokogiri"
require "erb"
require "net/http"
require "icalendar"
require "rss"
require "action_view"
require "redcarpet"

include ActionView::Helpers::DateHelper
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

markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

home_page = Nokogiri::HTML(File.read("home_page.html"))

about_section = make_section(home_page, "About")
events_section = make_section(home_page, "Events")
connect_section = make_section(home_page, "Connect")
just_visit_us_section = make_section(home_page, "Just Visit Us!")
everything_else_section = make_section(home_page, "Everything else")
template = ERB.new File.read("template.erb")

uri = URI("https://labitat.dk/events.ics")
calendar = Net::HTTP.get(uri)
cal = Icalendar::Calendar.parse(calendar).first
count = 0
events = cal.events.select { |e| e.dtstart > Time.now }.first(5)

wiki_changes = []
url = "https://labitat.dk/w/api.php?hidebots=1&days=30&limit=6&action=feedrecentchanges&feedformat=atom"
URI.open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|
    wiki_changes << item
  end
end

result = template.result
File.write("build/out.html", result)
