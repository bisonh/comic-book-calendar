require_relative '../comics-calendar'
require_relative '../helpers/comic-pages'


# test data
pages = [AUTUMNLANDS, DESCENDER]
comics_list = parse_comics_and_release_dates(pages)


describe 'parse_comics_and_release_dates' do
  it 'returns a hash' do
    expect(comics_list).to be_a_kind_of(Hash)
  end

  it 'the hash is not empty' do
    expect(comics_list).not_to be_empty
  end
end

describe 'filter_out_collections' do
  it 'returns a hash' do
    expect(filter_out_collections(comics_list)).to be_a_kind_of(Hash)
  end

end