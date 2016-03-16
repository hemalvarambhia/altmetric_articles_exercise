require 'csv'
describe 'Article CSV row' do
  def render article
    [article.doi, article.title, article.author]
  end

  it 'stores the DOI' do
    expected = '10.1234/altmetric0'
    article = double(:article).as_null_object
    
    expect(article).to receive(:doi).and_return expected
    row = render article     
    expect(row).to include expected
    expect(row.index(expected)).to eq 0
  end

  it 'stores the title' do
    expected = 'Chemistry article'
    article = double(:article).as_null_object

    expect(article).to receive(:title).and_return expected
    row = render article
    expect(row).to include expected
    expect(row.index(expected)).to eq 1
  end

  it 'stores author name' do
    expected = 'Chemist'
    article = double(:article).as_null_object
    
    expect(article).to receive(:author).and_return expected
    row = render article
    expect(row).to include expected
    expect(row.index(expected)).to eq 2
  end
end
