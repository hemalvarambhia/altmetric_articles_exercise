describe 'Article JSON Doc' do
  def render article
   {
      'doi' => article.doi, 
      'title' => article.title, 
      'author' => article.author,
      'issn' => article.issn,
      'journal' => article.journal
   }
  end

  it 'stores the DOI' do
    doi = '10.1234/altmetric0'
    article = double(:article).as_null_object

    expect(article).to receive(:doi).and_return doi
    expect(render(article)['doi']).to eq doi
  end

  it 'stores the title' do
    title = 'Physics article'
    article = double(:article).as_null_object

    expect(article).to receive(:title).and_return title
    expect(render(article)['title']).to eq title
  end

  it 'stores the author' do
    author = 'Physicists'
    article = double(:author).as_null_object

    expect(article).to receive(:author).and_return author
    expect(render(article)['author']).to eq author
  end

  describe 'an article with multiple authors' do
    it 'lists all the authors' do
      authors = ['Physicist 1', 'Physicist 2', 'Physicist 3']
      article = double(:article).as_null_object
      allow(article).to receive(:author).and_return authors

      expect(render(article)['author']).to eq authors
    end
  end

  it 'stores the ISSN' do
    issn = '1234-5678'
    article = double(:article).as_null_object

    expect(article).to receive(:issn).and_return issn  
    expect(render(article)['issn']).to eq issn
  end

  it 'stores the journal' do
    journal = 'Journal of Physics B'
    article = double(:article).as_null_object

    expect(article).to receive(:journal).and_return journal
    expect(render(article)['journal']).to eq journal
  end
end
