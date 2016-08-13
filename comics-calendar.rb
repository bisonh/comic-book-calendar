require 'date'
require 'nokogiri'
require 'open-uri'
require_relative './helpers/month_conv'
require_relative './helpers/comic-pages'
require_relative './helpers/helpers'


# creates a hash of comic issues and their release dates
# output: { "January 8, 2016" => ["Saga #30", "The Goddamned #4"] }
def get_titles_and_dates(series_pages)
  comics = {}
  series_pages.each do |page|
    titles = page.css('p.book__headline')
    release_dates = page.css('p.book__text')
    titles.each_with_index do |title, index|
      comic_title = title.text
      if single_issue?(comic_title)
        release_date = remove_published(release_dates[index].text)
        if comics.has_key?(release_date)
          comics[release_date].push(comic_title)
        else
          comics[release_date] = [comic_title]
        end
      end
    end
  end
  return comics
end


# format release dates as date objects
def format_release_dates(comics)
  list = {}
  comics.each do |title, release_date|
    split_date = release_date.split
    month = 0
    day = 0
    year = 0
    month += MONTH_AS_INT[split_date[0]]
    day += split_date[1].delete(',').to_i
    year += split_date[2].to_i
    release_date = Date.new(year, month, day)
    list[title] = release_date
  end
  return list
end


# sort releases by date
def sort_by_date(comics)
# input: hash, keys are strings and values are date objects
# steps:
  # new empty list

# output: hash, keys are strings sorted by and representing date object, values are an array of strings
# example: {}
end


# format release date for print view
def month_as_roman(date)
  puts "#{MONTH_AS_ROM[date.month]} #{date.mday}, #{date.year}\n"
end


# calculate cost
def total_cost(num_comics)
  subtotal = num_comics * 2.99
  tax = num_comics * 0.52
  total = (subtotal + tax).round(2)
end


# print comics and release dates
def print_releases(comics, month)
  num_comics = 0
  comics.each do |title, release_date|
    if release_date.mon == month && release_date.year >= Time.now.to_date.year
      month_as_roman(release_date)
      puts "#{title}\n\n"
      num_comics += 1
    end
  end
  puts "That'll set ya back $#{total_cost(num_comics)}\n\n"
  puts "-" * 40
  puts
end


# user input sets which month to show releases for
def user_input(comics)
  input = ""
  while input != 'exit'
    puts 'What month do you want to see comics for?'
    puts "Enter '1' for January, '2' for February, etc."
    puts "Type 'exit' to exit program."
    input = gets.chomp
    if input == 'exit'
      input.downcase!
    else
      input = input.to_i
      print_releases(comics, input)
    end
  end
end


def print_list(comics)
  comics.each do |title, release_date|
    puts "#{release_date}"
    puts "#{title}\n\n"
  end
end


# wrapper method to call all other methods
def create_calendar(pages)
  my_list = get_titles_and_dates(pages)
  p my_list
  # single_issues_list = remove_collections(my_list)
  # p single_issues_list
  # formatted_dates = format_release_dates(single_issues_list)
  # print_list(formatted_dates)
  # user_input(formatted_dates)
end


# Driver code
create_calendar(PAGES)