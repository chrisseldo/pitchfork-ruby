#!/usr/bin/env ruby

# Unofficial Pitchfork API for the Ruby language. 
# Ported from Python Pitchfork API: (https://github.com/michalczaplinski/pitchfork)

# Author: Christopher Selden
# Email: cbpselden@gmail.com 

require 'nokogiri'
require 'nokogiri-styles'

def replace_breaks(html):
  # Replaces all the <br> tags in the html with newlines '\n'
  breakline = html.br
  while html.br is not None:
    breakline.insert_before('\n')
    html.br.decompose()
    breakline = html.br
  return html
end