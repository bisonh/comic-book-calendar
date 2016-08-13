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