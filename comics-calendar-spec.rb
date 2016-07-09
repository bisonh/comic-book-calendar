require_relative 'comics-calendar'

saga = Nokogiri::HTML(open('https://imagecomics.com/comics/series/saga'))
paper_girls = Nokogiri::HTML(open('https://imagecomics.com/comics/series/paper-girls'))
comics = [saga, paper_girls]


describe 'all_comics' do
  it 'returns a hash' do
    expect(all_comics(saga)).to be_a_kind_of(Hash)
  end

  it 'is not empty an empty list' do
    expect(all_comics(comics)).not_to be_empty
  end
end