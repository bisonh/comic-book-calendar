require_relative 'comics-calendar'


# objects used to test program
saga = Nokogiri::HTML(open('https://imagecomics.com/comics/series/saga'))
paper_girls = Nokogiri::HTML(open('https://imagecomics.com/comics/series/paper-girls'))
comics = [saga, paper_girls]


describe 'all_comics' do
  it 'returns a hash' do
    expect(all_comics(comics)).to be_a_kind_of(Hash)
  end

  it 'is not empty an empty list' do
    expect(all_comics(comics)).not_to be_empty
  end
end

describe 'single_issues_only' do
  it 'returns a hash' do
    expect(single_issues_only_filter(comics)to be_a_kind_of(Hash))
  end

  it 'is not empty an empty list' do
    expect(single_issues_only_filter(comics)).not_to be_empty
  end

  it "filters out keys with 'vol' in the title" do
    expect(single_issues_only_filter(comics)).not_to include('vol')
  end

  it "filters out keys with ':' in the title" do
    expect(single_issues_only_filter(comics)).not_to include(':')
  end
end