require 'csv'
describe 'Article CSV row' do
  def render article
    [article.doi]
  end

  it 'stores the DOI' do
    expected = '10.1234/altmetric0'
    article = double :article

    expect(article).to receive(:doi).and_return expected     
    expect(render(article)).to include expected
  end
end
