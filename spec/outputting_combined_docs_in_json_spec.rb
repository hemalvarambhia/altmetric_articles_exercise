require 'support/create_doi'
require 'support/create_issn'
require 'support/create_author'
require 'support/journal_helper'
require 'in_format'
describe 'Outputting combined documents' do
  include CreateAuthor, JournalHelper, CreateDOI, CreateISSN

  before(:each) do
    @documents_combined = double(:documents_combined)
  end

  describe 'JSON format' do
    before :each do
      @format = 'json'
    end
    
    it 'publishes the DOI' do
      given_documents_combined_have a_row_with(doi: '10.1234/altmetric0')
      
      json_output = generate_output

      expect(json_output['doi']).to eq '10.1234/altmetric0'
    end

    it 'publishes the title' do
      given_documents_combined_have a_row_with(title: 'The R-matrix Method')
      
      json_output = generate_output

      expect(json_output['title']).to eq 'The R-matrix Method'
    end

    describe 'publishing the author' do
      context 'when there is none' do
        it 'publishes a blank' do
          given_documents_combined_have(
              a_row_with(author: CreateAuthor::NO_AUTHORS))
          
          json_output = generate_output

          expect(json_output['author']).to be_empty
        end
      end

      context 'when there is a single author' do
        it 'publishes their name' do
          given_documents_combined_have a_row_with(author: ['Physicist'])
          
          json_output = generate_output
          
          expect(json_output['author']).to eq 'Physicist'
        end
      end

      context 'when there is more than 1 author' do
        it 'publishes their names separated by a comma' do
          given_documents_combined_have(
            a_row_with(author: ['Main Author', 'Co-Author 1', 'Co-Author 2'])
          )

          json_output = generate_output

          expect(json_output['author'])
            .to eq 'Main Author,Co-Author 1,Co-Author 2'
        end
      end
    end

    describe 'publishing the journal title' do
      context 'when it is known' do
        it 'publishes the title of the journal' do
          given_documents_combined_have a_row_with(journal: 'J. Phys. B')
          
          json_output = generate_output

          expect(json_output['journal']).to eq 'J. Phys. B'
        end
      end

      context 'when it is not known' do
        it 'is left blank' do
          given_documents_combined_have(
              a_row_with(journal: JournalHelper::NO_SUCH_JOURNAL))
          
          json_output = generate_output
          
          expect(json_output['journal']).to be_empty
        end
      end
    end

    it 'publishes the ISSN' do
      given_documents_combined_have a_row_with(issn: '1234-5678')
      
      json_output = generate_output

      expect(json_output['issn']).to eq '1234-5678'
    end
  end

  def given_documents_combined_have(*rows)
    allow(@documents_combined).to receive(:read).and_return *rows
  end
  
  def generate_output
    formatter = InFormat.output(@format, @documents_combined)
    formatter.output_in.first
  end

  def a_row_with(params)
    [ a_row.merge(params) ]
  end

  def a_row
    {
      doi: generate_doi, title: 'Academic Publication',
      author: authors, journal: 'An Academic Journal',
      issn: generate_issn
    }
  end
end
