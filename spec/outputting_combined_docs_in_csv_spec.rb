require 'support/create_doi'
require 'support/create_issn'
require 'author_helper'
require 'journal_helper'
require 'in_format'
describe 'Outputting combined documents' do
  include CreateAuthor, JournalHelper, CreateDOI, CreateISSN

  before(:each) do
    @documents_combined = double(:documents_combined)
  end

  describe 'CSV format' do
    before(:each) do
      @format = 'csv'
    end
    
    it 'publishes the DOI in column 1' do
      given_documents_combined_have a_row_with(doi: '10.1234/altmetric1')
      
      csv_output = generate_output
      
      expect(csv_output).to have('10.1234/altmetric1').in_column 0
    end

    it 'publishes the title in column 2' do
      given_documents_combined_have a_row_with(title: 'Scattering Theory')
      
      csv_output = generate_output

      expect(csv_output).to have('Scattering Theory').in_column 1
    end

    describe 'publishing authors' do
      context 'given the article has only a single author' do
        it 'publishes the author in column 3' do
          given_documents_combined_have(a_row_with(author: ['Paul Dirac']))
      
          csv_output = generate_output
          
          expect(csv_output).to have('Paul Dirac').in_column 2
        end
      end

      context 'given the article has multiple authors' do
        it 'publishes their names comma-separated in column 3' do
          given_documents_combined_have(
            a_row_with(author: [ 'P Dirac', 'M Born', 'W Heisenberg' ])
          )
          
          csv_output = generate_output
          
          expect(csv_output)
            .to have('P Dirac,M Born,W Heisenberg').in_column 2
        end
      end
    end

    describe 'publishing the journal title' do
      context 'when it is known' do
         it 'publishes the journal title in column 4' do
           given_documents_combined_have a_row_with(journal: 'Nature')
          
           csv_output = generate_output
          
           expect(csv_output).to have('Nature').in_column 3
         end
      end

      context 'when it is not known' do
         it 'publishes a blank title in column 4' do
           given_documents_combined_have(
               a_row_with(journal: JournalHelper::NO_SUCH_JOURNAL))
          
           csv_output = generate_output
          
           expect(csv_output).to have('').in_column 3
         end
      end
    end

    it 'publishes the ISSN in column 5' do
      given_documents_combined_have a_row_with(issn: '1234-5678')
      
      csv_output = generate_output
      
      expect(csv_output).to have('1234-5678').in_column 4
    end
    
    RSpec::Matchers.define :have do |expected_field|
      match do |csv_row|
        csv_row[@index] == expected_field
      end

      chain :in_column do |offset|
        @index = offset
      end

      chain :last do
        @index = -1
      end

      failure_message do |csv_row|
        message = "Expected #{csv_row.inspect} to have '#{expected_field}' "
        message << "at position #{@index}"

        message
      end
    end
  end

  it 'formats all rows from the combined documents' do
    content = Array.new(3) { a_row }
    format = ['json','csv'].sample
    given_documents_combined_have content
    formatter = InFormat.output(format, @documents_combined)

    csv_output = formatter.output_in

    expect(csv_output.size).to eq content.size
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
