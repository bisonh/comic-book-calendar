require 'date'
require_relative 'month_conv'
require_relative 'nokogiri-objects'


# class names for locating info while scraping
COMIC_NAME = 'p.book__headline'
RELEASE_DATE = 'p.book__text'


# helper function to format release date as Date obj
def format_date_obj(calendar, title, date)
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
  calendar[title.text] = Date.new(year, month, day)
end


# helper function to format release date for print view
def format_date_print_view(date)
  puts "#{MONTH_AS_ROM[date.month]} #{date.mday}, #{date.year}\n\n"
end


# pull info from pages and store in list
def record_releases(pages)
  releases = {}
  pages.each do |series|
    issues = series.css(COMIC_NAME)
    release_dates = series.css(RELEASE_DATE)
    issues.each_with_index do |title, index|
      format_date_obj(releases, title, release_dates[index])
    end
  end
  return releases
end


# print all comics for a specific series
def list_all(series)

end


# old method to print releases
def old_print_releases(calendar, month)
  calendar.each do |title, release_date|
    if release_date.mon == month && release_date.year >= Time.now.to_date.year
      print "#{title}\n"
      format_date_print_view(release_date)
    end
  end
end


# collect releases by month
def monthly_releases(calendar, month)
  monthly_releases = {}
  calendar.each do |title, release_date|
    if release_date.mon == month && release_date.year >= Time.now.to_date.year
      monthly_releases[title] = release_date
      print "#{title}\n"
      format_date_print_view(release_date)
    end
  end
  return monthly_releases
end


# sort releases by date
def sort_by_date(comics)

end


# print new issues by release date
def print_list(comics)

end


# user input sets which month to show releases for
def user_input(releases)
  puts 'What month do you want to see releases for?'
  puts "Enter '1' for January, '2' for February, etc."
  input = gets.chomp.to_i
  old_print_releases(releases, input)
  # comics = monthly_releases(releases, input)
  # sorted_comics = sort_by_date(comics)
  # print_list(sorted_comics)
end


# cost of comics $2.99
# tax = $0.52
# total per comic = $3.51


# driver code
releases = record_releases(PAGES)
user_input(releases)