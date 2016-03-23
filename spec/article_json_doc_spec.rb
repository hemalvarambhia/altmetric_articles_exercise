describe 'Article JSON Doc' do
  def render article
   {
      'doi' => article.doi, 
      'title' => article.title, 
      'author' => article.author.join(', '),
      'issn' => article.issn,
      'journal' => article.journal
   }
  end

  it 'publishes the DOI' do
    doi = '10.1234/altmetric0'
    article = double(:article).as_null_object

    expect(article).to receive(:doi).and_return doi
    expect(render(article)['doi']).to eq doi
  end

  it 'publishes the title' do
    title = 'Physics article'
    article = double(:article).as_null_object

    expect(article).to receive(:title).and_return title
    expect(render(article)['title']).to eq title
  end

  it 'publishes the author' do
    author = ['Physicist']
    article = double(:author).as_null_object

    expect(article).to receive(:author).and_return author
    expect(render(article)['author']).to eq 'Physicist'
  end

  describe 'an article with multiple authors' do
    it 'publishes all the authors comma separated' do
      authors = ['Physicist 1', 'Physicist 2', 'Physicist 3']
      article = double(:article).as_null_object
      allow(article).to receive(:author).and_return authors

      expect(render(article)['author']).
        to eq 'Physicist 1, Physicist 2, Physicist 3'
    end
  end

  it 'publishes the ISSN' do
    issn = '1234-5678'
    article = double(:article).as_null_object

    expect(article).to receive(:issn).and_return issn  
    expect(render(article)['issn']).to eq issn
  end

  it 'publishes the journal' do
    journal = 'Journal of Physics B'
    article = double(:article).as_null_object

    expect(article).to receive(:journal).and_return journal
    expect(render(article)['journal']).to eq journal
  end
end
