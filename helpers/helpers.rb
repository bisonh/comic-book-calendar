# remove published from release date
def remove_published(date)
  split_date = date.split
  split_date.shift
  split_date.join(' ')
end


# filter out volumes and special editions
# output: { "saga #30" => "Published: January 8, 2016" }
def remove_collections(comics)
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