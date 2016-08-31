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
  tax = num_comics * 0.283
  total = (subtotal + tax).round(2)
end


# filter comics by month and sort by date
def selected_comics(comics, month)
  selected_comics = {}
  comics.each do |release_date, titles|
    if release_date.mon == month && release_date.year >= Time.now.to_date.year
      selected_comics[release_date] = titles
    end
  end
  selected_comics.sort.to_h
end


# format date object for print view
def format_date_print_view(date)
  print "#{MONTH_AS_ROM[date.month]} #{date.mday}, #{date.year}"
end


# display comics and release dates in CLI
def print_releases(comics)
  num_comics = 0
  comics.each do |release_date, titles|
    puts format_date_print_view(release_date)
    titles.each do |title|
      puts "#{title}"
      num_comics += 1
    end
    puts
  end
  puts "That'll set ya back $#{total_cost(num_comics)}\n\n"
  puts "-" * 40
  puts
end