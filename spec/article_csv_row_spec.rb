require 'csv'
describe 'Article CSV row' do
  def render article
    [
      article.doi,
      article.title,
      article.author.join(', '),
      article.journal,
      article.issn
    ]
  end

  it 'publishes the DOI in the 1st column' do
    doi = '10.1234/altmetric0'
    article = double(:article).as_null_object    

    expect(article).to receive(:doi).and_return doi
    expect(render(article)).to have(doi).in_column 1
  end

  it 'publishes the title in the 2nd column' do
    title = 'Chemistry article'
    article = double(:article).as_null_object

    expect(article).to receive(:title).and_return title
    expect(render(article)).to have(title).in_column 2
  end

  it 'publishes author name in the 3rd column' do
    author = ['Chemist']
    article = double(:article).as_null_object    

    expect(article).to receive(:author).and_return author
    expect(render(article)).to have('Chemist').in_column 3
  end

  describe 'an article with multiple authors' do
    it 'publishes all the authors as a comma-separated list' do
      authors = ['Chemist 1', 'Chemist 2', 'Chemist 3']
      article = double(:article).as_null_object
      allow(article).to receive(:author).and_return authors

      expect(render(article)[2]).to eq 'Chemist 1, Chemist 2, Chemist 3'
    end
  end

  it 'publishes the journal in the 4th column' do
    journal = 'Journal of Physics B'
    article = double(:article).as_null_object

    expect(article).to receive(:journal).and_return journal
    expect(render(article)).to have(journal).in_column 4
  end

  it "publishes the journal's ISSN in the last column" do
    issn = '1234-5678'
    article = double(:article).as_null_object

    expect(article).to receive(:issn).and_return issn
    expect(render(article)).to have(issn).in_column 5
  end

  RSpec::Matchers.define :have do |expected|
    match do |row|
      row.include?(expected) and row.index(expected) == @expected_index
    end

    chain :in_column do |column_number|
      @expected_index = column_number - 1
    end

    failure_message do |row|
      column = @expected_index + 1
      "Expected #{row} to include '#{expected}' in column #{column}"
    end
  end
end
