describe 'Article JSON Doc' do
  def render article
   {
      'doi' => article.doi, 
      'title' => article.title, 
      'author' => article.author,
      'issn' => article.issn
   }
  end

  it 'stores the DOI' do
    expected = a_doi
    article = double(:article).as_null_object
    expect(article).to receive(:doi).and_return expected
    article_json_doc = render article

    expect(article_json_doc['doi']).to eq expected
  end

  it 'stores the title' do
    expected = 'Physics article'
    article = double(:article).as_null_object
    expect(article).to receive(:title).and_return expected

    article_json_doc = render article

    expect(article_json_doc['title']).to eq expected
  end

  it 'stores the author' do
    expected = 'Physicists'
    article = double(:author).as_null_object
    expect(article).to receive(:author).and_return expected

    article_json_doc = render article

    expect(article_json_doc['author']).to eq expected
  end

  it 'stores the ISSN' do
    expected = '1234-5678'
    article = double(:article).as_null_object
    expect(article).to receive(:issn).and_return expected
  
    article_json_doc = render article
 
    expect(article_json_doc['issn']).to eq expected
  end

  def a_doi
    "10.1234/altmetric#{rand(10000)}"
  end
end
