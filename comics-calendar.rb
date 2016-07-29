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
    if title.include?('#')
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


# helper function to remove commas from dates
# def remove_commas(comics)
def remove_commas(date)
  date.delete(',')
  return date
  # comics_formatted_date = {}
  # comics.each do |title, date|
  #   comics_formatted_date[title] = date.delete(',')
  # end
  # return comics_formatted_date
end


# formatting helper to set release dates as date objects
def format_release_dates_as_date_objects(comics)
  formatted_comics_list = {}
  # p comics
  comics.each do |title, release_date|
    split_date = release_date.split
    month = 0
    day = 0
    year = 0
    month += MONTH_AS_INT[split_date[0]]
    day += remove_commas(split_date[1]).to_i
    year += split_date[2].to_i
    release_date = Date.new(year, month, day)
    formatted_comics_list[title] = release_date
  end
  return formatted_comics_list

  # month = 0
  # day = 0
  # year = 0
  # comics.each_value do |date|
  #   split_date = date.text.split(' ')
  # end
  # split_date = comics.date.text.split(' ')
  # if split_date.include?('Published:')
  #   split_date.shift
  # end

  # month += MONTH_AS_INT[split_date[0]]
  # day += split_date[1].to_i
  # year += split_date[2].to_i
  # comics[title.text] = Date.new(year, month, day)
end

def format_date_obj_offline(comics)
  formatted_comics_list = {}
  comics.each do |title, release_date|
    month = 0
    day = 0
    year = 0
    month += MONTH_AS_INT[release_date[0]]
    day += release_date[1].to_i
    year += release_date[2].to_i
    release_date = Date.new(year, month, day)
    formatted_comics_list[title] = release_date
  end
  return formatted_comics_list
end


def old_format_date_obj(calendar, title, date)
  month = 0
  day = 0
  year = 0
  split_date = date.text.split(' ')
  # p split_date
  # month += MONTH_AS_INT[split_date[0]]
  # day += split_date[1].to_i
  # year += split_date[2].to_i
  # calendar[title.text] = Date.new(year, month, day)
end





# split dates
def date_splitter(comics)
  comics_split_date = {}
  comics.each do |title, date|
    comics_split_date[title] = date.split
  end
  return comics_split_date
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
      print "#{title}\n"
      format_date_print_view(release_date)
      num_comics += 1
    end
  end
  puts "That'll set ya back $#{total_cost(num_comics)}"
end


# format release date for print view
def format_date_print_view(date)
  puts "#{MONTH_AS_ROM[date.month]} #{date.mday}, #{date.year}\n\n"
end


# user input sets which month to show releases for
def user_input(comics)
  puts 'What month do you want to see comics for?'
  puts "Enter '1' for January, '2' for February, etc."
  month = gets.chomp.to_i
  old_print_releases(comics, month)
end


# get calendar offline
def calendar(comics)
  # comics_list = all_comics_offline(comics)

  comics_list = all_comics(comics)
  # comics_list_filtered = single_issues_only_filter(comics_list)
  # comics_list_without_commas = remove_commas(comics_list_filtered)
  # comics_list_split_date = date_splitter(comics_list_without_commas)

  # formatted_list = format_date_obj_offline(comics_list_split_date)

  # formatted_list = format_date_obj(comics_list_split_date)

  # user_input
end


# format console output
def pretty_print(comics)
  comics.each do |comic, release_date|
    puts "#{comic}\n#{release_date}\n\n"
  end
end


# scaping driver code
# releases = all_comics(PAGES)
# user_input(releases)



# offline driver code
# series_list = {'Sweet Tooth Vol. 1' => 'January 2, 2016', 'Sweet Tooth #1' => 'January 5, 2015', 'Sweet Tooth #2' => 'January 17, 2016', 'Sweet Tooth: The First Collection' => 'January 2, 2016'}

# comics = calendar(comic_documents)
# p comics


# p total_cost(0) == 0
# p total_cost(1) == 3.51
# p total_cost(5) == 17.55

def create_calendar(pages)
  my_list = parse_comics_and_release_dates(pages)
  single_issues_list = filter_out_collections(my_list)
  filtered_release_dates = filter_out_heading_from_release_dates(single_issues_list)
  formatted_dates = format_release_dates_as_date_objects(filtered_release_dates)
  pretty_print(filtered_release_dates)
end


# Driver code
# create_calendar(PAGES)
create_calendar(TESTER_PAGES)