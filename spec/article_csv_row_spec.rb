require 'csv'
describe 'Article CSV row' do
  def render article
    [article.doi, article.title]
  end

  it 'stores the DOI' do
    expected = '10.1234/altmetric0'
    article = double(:article).as_null_object
    
    expect(article).to receive(:doi).and_return expected     
    expect(render(article)).to include expected
  end

  it 'stores the title' do
    expected = 'Chemistry article'
    article = double(:article).as_null_object

    expect(article).to receive(:title).and_return expected
    expect(render(article)).to include expected
  end
end