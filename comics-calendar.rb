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
        release_date = format_release_date(remove_published(release_dates[index].text))
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
      this_months_savers = selected_comics(comics, input)
      print_releases(this_months_savers)
    end
  end
end


# wrapper method to call all other methods
def create_calendar(pages)
  my_list = get_titles_and_dates(pages)
  user_input(my_list)
end


# DRIVER CODE
create_calendar(PAGES)