#!/usr/bin/env ruby


# Unofficial Pitchfork API for the Ruby language. 
# Ported from Python Pitchfork API: (https://github.com/michalczaplinski/pitchfork)

# Author: Christopher Selden
# Email: cbpselden@gmail.com 

require "nokogiri"
# require 'nokogiri-styles'
require "json"
require "httparty"
require "uri"

# def replace_breaks(html)
#   # Replaces all the <br> tags in the html with newlines '\n'
#   breakline.styles = html['br']
#   while html['br'] != nil
#     breakline = ['\n']
#     html.br.decompose()
#     breakline.styles = html['br']
#   return html
# end

class Review

#   # Class representing the fetched review.
#   # Includes methods for getting the score, the text of the review
#   # (editorial), the album cover, label, year as well as the true
#   # (matched) album and artist names.
  def initialize(blob)
  # def initialize(searched_artist, searched_album, matched_artist,
  #                matched_album, query, url, blob)
    # @searched_artist = searched_artist
    # @searched_album = searched_album
    # @matched_artist = matched_artist
    # @matched_album = matched_album
    # @query = query
    # @url = url
    @blob = blob
  end

  def score
    # Returns the album score. 
    # rating = @blob.xpath(@class='score')
    # puts rating
    # rating = rating[0].to_f
    # return rating
  end

#   def self.editorial
#     # Returns the text of the review. 
#     review_html = @blob.find(class_='editorial')
#     review_html = replace_breaks(review_html).find_all('p')
#     review_text = ''
#     for paragraph in review_html
#       review_text += paragraph.text + '\n\n'
#     return review_text
#   end

#   def self.cover
#     # Returns the link to the album cover on the Pitchfork review page. 
#     artwork = @blob.find(class_='artwork')
#     image_link = artwork.img['src'].strip
#     return image_link
#   end

#   def self.artist
#     # Returns the artist name that Pitchfork matched to our search. 
#     artist = @matched_artist.strip
#     return artist
#   end

#   def album
#     # Returns the album name that Pitchfork matched to our search. 
#     album = @matched_album.strip
#     return album
#   end

#   def label
#     # Returns the name of the record label that released the album. 
#     label = @soup.find(class_='info').h3.get_text
#     label = label[:label.index(';')].strip
#     return label
#   end
end


def search(artist, album)
  # subbing spaces with '%20' 
  query = (artist + "%20" + album)
  query = query.gsub(" ", "%20")
  # making request to Pitchfork API
  request = HTTParty.get("http://pitchfork.com/search/ac/?query=" + query,
                        headers: {"User-Agent" => "chrisseldo/pitchfork-ruby-v0.1"})
  responses = JSON.parse(request.body)
  
  begin 
    # creating array of reviews if there exists review(s)
    response = responses.collect {|x| x if x["label"] == "Reviews"}
    review_hash = response[1]['objects'][0]
  rescue 
    puts "Found no reviews for this artist/album!"
  end

  url = review_hash["url"]
  matched_artist = review_hash["name"].split(' - ')[0]

  full_url = URI::join('http://pitchfork.com', url)
  request = HTTParty.get(full_url,
               headers: {"User-Agent" => "chrisseldo/pitchfork-ruby-v0.1"})
  response = request.body
  
  blob = Nokogiri::HTML(response) do |config|
    config.noerror
  end
  
  if blob.css('review-multi').empty?
    matched_album = review_hash['name'].split(' - ')[1]
    a = Review.new(blob)
  else 
    puts blob
  end

end