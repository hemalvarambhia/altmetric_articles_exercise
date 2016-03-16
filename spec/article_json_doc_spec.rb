describe 'Article JSON Doc' do
  def render article
   {'doi' => '10.1234/altmetric0'}
  end

  it 'stores the DOI' do
    expected = '10.1234/altmetric0'
    article = double :article
    allow(article).to receive(:doi).and_return expected
    article_json_doc = render article

    expect(article_json_doc['doi']).to eq expected
  end
end
