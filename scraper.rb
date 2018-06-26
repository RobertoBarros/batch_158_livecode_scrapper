require 'open-uri'
require 'nokogiri'

def fetch_top_movie_urls
  top_movies_url = 'https://www.imdb.com/chart/top'
  urls = []
  html_file = open(top_movies_url).read
  html_doc = Nokogiri::HTML(html_file)
  html_doc.search(".titleColumn a").each do | result |
    href = result.attributes["href"].value
    href = href.scan(/\/title\/\w+\//).first
    urls << "https://www.imdb.com#{href}"
  end
  return urls.first(5)
end

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)

  director = html_doc.search('span[itemprop=director]').text.strip
  storyline = html_doc.search('.summary_text').text.strip
  title_with_year = html_doc.search('h1').text.strip

  pattern = /(?<title>.*).\((?<year>\d{4})\)$/
  title = title_with_year.match(pattern)[:title]
  year = title_with_year.match(pattern)[:year]

  cast = []
  html_doc.search('span[itemprop=actors]').each do |actor|
   cast << actor.text.delete(',').strip
  end

  result = {
    title: title,
    cast: cast,
    director: director,
    storyline: storyline,
    year: year.to_i
  }

  p result
end

