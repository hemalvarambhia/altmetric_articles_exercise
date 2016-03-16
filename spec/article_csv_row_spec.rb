require 'csv'
describe 'Article CSV row' do
  def render article
    [article.doi, article.title, article.author, article.journal, article.issn]
  end

  it 'stores the DOI in the 1st column' do
    expected = '10.1234/altmetric0'
    article = double(:article).as_null_object
    
    expect(article).to receive(:doi).and_return expected
    expect(render(article)).to have(expected).in_column 1
  end

  it 'stores the title in the 2nd column' do
    expected = 'Chemistry article'
    article = double(:article).as_null_object

    expect(article).to receive(:title).and_return expected
    expect(render(article)).to have(expected).in_column 2
  end

  it 'stores author name in the 3rd column' do
    expected = 'Chemist'
    article = double(:article).as_null_object
    
    expect(article).to receive(:author).and_return expected
    expect(render(article)).to have(expected).in_column 3
  end

  it 'stores the journal in the 4th column' do
    expected = 'Journal of Physics B'
    article = double(:article).as_null_object

    expect(article).to receive(:journal).and_return expected
    expect(render(article)).to have(expected).in_column 4
  end

  it "stores the journal's ISSN in the last column" do
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
