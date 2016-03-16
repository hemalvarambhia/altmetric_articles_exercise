require 'csv'
describe 'Article CSV row' do
  def render article
    [article.doi, article.title, article.author]
  end

  it 'stores the DOI in the 1st column' do
    expected = '10.1234/altmetric0'
    article = double(:article).as_null_object
    
    expect(article).to receive(:doi).and_return expected
    row = render article     
    expect(row).to have(expected).in_column 1
  end

  it 'stores the title in the 2nd column' do
    expected = 'Chemistry article'
    article = double(:article).as_null_object

    expect(article).to receive(:title).and_return expected
    row = render article
    expect(row).to have(expected).in_column 2
  end

  it 'stores author name in the 3rd column' do
    expected = 'Chemist'
    article = double(:article).as_null_object
    
    expect(article).to receive(:author).and_return expected
    row = render article
    expect(row).to have(expected).in_column 3
  end

  RSpec::Matchers.define :have do |expected|
    match do |row|
      row.include?(expected) and row.index(expected) == @expected_index
    end

    chain :in_column do |column_number|
      @expected_index = column_number - 1
    end

    failure_message do |row|
      "Expected #{row} to include '#{expected}' in column #{@expected_index}"
    end
  end
end
