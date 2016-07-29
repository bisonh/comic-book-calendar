require 'date'
require 'nokogiri'
require 'open-uri'
require_relative './helpers/month_conv'
require_relative './helpers/comic-pages'


# creates a hash of comic issues and their release dates
def parse_comics_and_release_dates(series_pages)
  comics = {}
  series_pages.each do |page|
    titles = page.css('p.book__headline')
    release_dates = page.css('p.book__text')
    titles.each_with_index do |title, index|
      comics[title.text] = release_dates[index].text
    end
  end
  return comics
end


# filter out volumes and special editions
def filter_out_collections(comics)
  single_issues = {}
  comics.each do |title, release_date|
    if title.include?('#') && !title.include?('free #1')
      if !title.downcase.include?('vol') && !title.include?(':')
        single_issues[title] = release_date
      end
    end
  end
  return single_issues
end


# filter out 'published' from release dates
def filter_out_heading_from_release_dates(comics)
  list = {}
  comics.each do |title, release_date|
    split_date = release_date.split
    split_date.shift
    list[title] = split_date.join(' ')
  end
  return list
end


# formatting helper to set release dates as date objects
def format_release_dates_as_date_objects(comics)
  formatted_comics_list = {}
  comics.each do |title, release_date|
    split_date = release_date.split
    month = 0
    day = 0
    year = 0
    month += MONTH_AS_INT[split_date[0]]
    day += split_date[1].delete(',').to_i
    year += split_date[2].to_i
    release_date = Date.new(year, month, day)
    formatted_comics_list[title] = release_date
  end
  return formatted_comics_list
end


# sort releases by date
def sort_by_date(comics)
  # new list variable
  # comparison new date at first of month
  # iterate through comics list
    # IF release date is less than comparison
      # comparison becomes key
      # value is an an empty array
      # push title onto array
    # ELSIF release date is equal to comparison
      # push title onto array
    # ELSE
      #
end


# calculate cost
def total_cost(num_comics)
  subtotal = num_comics * 2.99
  tax = num_comics * 0.52
  total = (subtotal + tax).round(2)
end


# print comics and release dates
def old_print_releases(comics, month)
  num_comics = 0
  comics.each do |title, release_date|
    if release_date.mon == month && release_date.year >= Time.now.to_date.year
      format_date_print_view(release_date)
      puts "#{title}\n\n"
      num_comics += 1
    end
  end
  puts "That'll set ya back $#{total_cost(num_comics)}\n\n"
  puts "-" * 40
  puts
end


# user input sets which month to show releases for
# should figure out how to loop this so several months can be seen at once
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
      old_print_releases(comics, input)
    end
  end
end


#### the code below here needs to be organized so pretty_print registers with user_input #####

# format release date for print view
def format_date_print_view(date)
  puts "#{MONTH_AS_ROM[date.month]} #{date.mday}, #{date.year}\n"
end


# wrapper method to call all other methods
def create_calendar(pages)
  my_list = parse_comics_and_release_dates(pages)
  single_issues_list = filter_out_collections(my_list)
  filtered_release_dates = filter_out_heading_from_release_dates(single_issues_list)
  formatted_dates = format_release_dates_as_date_objects(filtered_release_dates)
  # pretty_print(filtered_release_dates)
  user_input(formatted_dates)
end


# Driver code
create_calendar(PAGES)