# remove published from release date
def remove_published(date)
  split_date = date.split
  split_date.shift
  split_date.join(' ')
end


# filter out volumes and special editions
def single_issue?(title)
  if title.include?('#') && !title.downcase.include?('free #1')
    return !title.downcase.include?('vol') && !title.include?(':')
  end
end


# format release dates as date objects
def format_release_date(date)
  split_date = date.split
  month = 0
  day = 0
  year = 0
  month += MONTH_AS_INT[split_date[0]]
  day += split_date[1].delete(',').to_i
  year += split_date[2].to_i
  Date.new(year, month, day)
end


# calculate cost
def total_cost(num_comics)
  subtotal = num_comics * 2.99
  tax = num_comics * 0.52
  total = (subtotal + tax).round(2)
end


# display comics and release dates in CLI
def print_releases(comics, month)
  num_comics = 0
  comics.each do |release_date, titles|
    date_object = format_release_date(release_date)
    if date_object.mon == month && date_object.year >= Time.now.to_date.year
      puts release_date
      titles.each do |title|
        puts "#{title}"
        num_comics += 1
      end
      puts
    end
  end
  puts "That'll set ya back $#{total_cost(num_comics)}\n\n"
  puts "-" * 40
  puts
end