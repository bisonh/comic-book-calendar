require 'nokogiri'
require 'open-uri'


# scraped HTML from individual series pages
AUTUMNLANDS = Nokogiri::HTML(open('https://imagecomics.com/comics/series/tooth-and-claw'))
DESCENDER = Nokogiri::HTML(open('https://imagecomics.com/comics/series/descender'))
GODDAMNED = Nokogiri::HTML(open('https://imagecomics.com/comics/series/the-goddamned'))
INJECTION = Nokogiri::HTML(open('https://imagecomics.com/comics/series/injection'))
PAPER_GIRLS = Nokogiri::HTML(open('https://imagecomics.com/comics/series/paper-girls'))
SAGA = Nokogiri::HTML(open('https://imagecomics.com/comics/series/saga'))
SOUTHERN_BASTARDS = Nokogiri::HTML(open('https://imagecomics.com/comics/series/southern-bastards'))


# collection of scraped pages
PAGES = [AUTUMNLANDS, DESCENDER, GODDAMNED, INJECTION, PAPER_GIRLS, SAGA, SOUTHERN_BASTARDS, TREES]
# PAGES = [AUTUMNLANDS, DESCENDER]


# class names for locating info while scraping
COMIC_NAME_NODE = 'p.book__headline'
RELEASE_DATE_NODE = 'p.book__text'