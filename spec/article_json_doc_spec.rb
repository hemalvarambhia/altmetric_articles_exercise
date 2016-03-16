describe 'Article JSON Doc' do
  def render article
   {'doi' => article.doi }
  end

  it 'stores the DOI' do
    expected = a_doi
    article = double :article
    expect(article).to receive(:doi).and_return expected
    article_json_doc = render article

    expect(article_json_doc['doi']).to eq expected
  end

  def a_doi
    "10.1234/altmetric#{rand(10000)}"
  end
end
