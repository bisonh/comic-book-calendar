require 'date'
require_relative 'month_conv'
require_relative 'nokogiri-objects'


# class names for locating info while scraping
COMIC_NAME = 'p.book__headline'
RELEASE_DATE = 'p.book__text'


# create a list of comics and their release dates
def all_comics(noko_objs)
  comics = {}
  noko_objs.each do |series|
    issues = series.css(COMIC_NAME)
    release_dates = series.css(RELEASE_DATE)
    issues.each_with_index do |title, index|
      format_date_obj(comics, title, release_dates[index])
    end
  end
  return comics
end


# remove traders and special edition sets
def single_issues_only(comics)

end


# format release dates as date objects
def format_date_obj(comics, title, date)
  month = 0
  day = 0
  year = 0
  split_date = date.text.split(' ')
  if split_date.include?('Published:')
    split_date.shift
  end

  month += MONTH_AS_INT[split_date[0]]
  day += split_date[1].to_i
  year += split_date[2].to_i
  comics[title.text] = Date.new(year, month, day)
end


# sort releases by date
def sort_by_date(comics)

end


# calculate cost
def total_cost(num_comics)
  subtotal = num_comics * 2.99
  tax = num_comics * 0.52
  total = subtotal + tax
  total.round(2)
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
def user_input(releases)
  puts 'What month do you want to see releases for?'
  puts "Enter '1' for January, '2' for February, etc."
  input = gets.chomp.to_i
  old_print_releases(releases, input)
end


# cost of comics $2.99
# tax = $0.52
# total per comic = $3.51


# driver code
releases = all_comics(PAGES)
user_input(releases)