require 'doi_helper'
require 'issn_helper'
describe 'Article' do
  include CreateDOI, CreateISSN

  class Article
    def initialize(args)
      @doi = args[:doi]
      @issn = args[:issn]
      @title = args[:title]
      @journal = args[:journal]
      @author = args.fetch(:authors, [])
    end

    def as_json
      { 
        'doi' => @doi, 
        'title' => @title,
        'author' => @author.join(','),
        'journal' => @journal,
        'issn' => @issn
      }
    end

    def as_csv
      [ @doi ]
    end
  end
 
  describe '#as_json' do
    it 'renders the DOI' do
      expected = a_doi
      article = Article.new(doi: expected)

      article_json = article.as_json

      expect(article_json).to include('doi' => expected)
    end

    it 'renders the title' do
      expected = 'The R-Matrix Method'
      article = Article.new(title: expected)

      article_json = article.as_json

      expect(article_json).to include('title' => expected)
    end

    it 'renders the authors' do
      authors = ['Author 1', 'Co-Author 1', 'Co-Author 2']
      expected = authors.join(',')
      article = Article.new(authors: authors)

      article_json = article.as_json

      expect(article_json).to include('author' => expected)
    end

    it 'renders the title of the journal' do
      expected = 'Journal of Physics B'
      article = Article.new(journal: expected)

      article_json = article.as_json

      expect(article_json).to include('journal' => expected)
    end

    it 'renders the ISSN' do
      expected = an_issn
      article = Article.new(issn: expected)
      
      article_json = article.as_json

      expect(article_json).to include('issn' => expected)
    end
  end

  describe '#as_csv' do
    it 'renders the DOI' do
      expected = a_doi
      article = Article.new(doi: expected)

      article_csv = article.as_csv

      expect(article_csv).to have(expected).at_position(1)
    end
 
    it 'renders the title'

    it 'renders the authors'

    it 'renders the title of the journal'

    it "renders the journal's ISSN"

    RSpec::Matchers.define :have do |expected|
      match do |actual|
        actual.include?(expected) and actual.index(expected) == @expected_position
      end

      chain :at_position do |position|
        @expected_position = position - 1
      end

      failure_message_for_should do |actual|
       "expected that #{actual} would contain of #{expected} at position #{@expected_position}≈ß"
      end
    end
  end
end