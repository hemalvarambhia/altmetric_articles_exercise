describe 'Outputting combined documents' do
  class InFormat
    def output_in format, document
      return as_json(document.read) if format == 'json'
      [ document.read[:doi] ]
    end

    private

    def as_json row
      {
        'doi' => row[:doi],
        'title' => row[:title],
        'author' => comma_separated(row[:author]),
        'journal' => row[:journal].to_s,
        'issn' => row[:issn]
      }
    end

    def comma_separated authors
      authors.join(',')
    end
  end

  before(:each) { @formatter = InFormat.new }

  describe 'JSON format' do
    before :each do
      @format = 'json'
      @documents_combined = double(:documents_combined)
    end
    
    it 'publishes the DOI' do
      a_row = a_row_with({ doi: '10.1234/altmetric0' })
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      formatter = InFormat.new
      
      output = @formatter.output_in(@format, @documents_combined)

      expect(output['doi']).to eq '10.1234/altmetric0'
    end

    it 'publishes the title' do
      a_row = a_row_with(title: 'The R-matrix Method')
      allow(@documents_combined).to(receive(:read).and_return a_row)
      
      output = @formatter.output_in(@format, @documents_combined)

      expect(output['title']).to eq 'The R-matrix Method'
    end

    describe 'publishing the author' do
      context 'when there is none' do
        it 'publishes a blank' do
          no_author = []
          a_row = a_row_with(author: no_author)
          allow(@documents_combined).to(receive(:read).and_return a_row)
          
          json_output = @formatter.output_in @format, @documents_combined

          expect(json_output['author']).to be_empty
        end
      end

      context 'when there is a single author' do
        it 'publishes their name' do
          a_row = a_row_with(author: [ 'Physicist' ])
          allow(@documents_combined)
            .to(receive(:read).and_return a_row) 
          
          json_output = @formatter.output_in @format, @documents_combined
          
          expect(json_output['author']).to eq 'Physicist'
        end
      end

      context 'when there is more than 1 author' do
        it 'publishes their names separated by a comma' do
          a_row = a_row_with(
            author: ['Main Author', 'Co-Author 1', 'Co-Author 2'])
          allow(@documents_combined)
            .to(receive(:read).and_return a_row)

          json_output = @formatter.output_in @format, @documents_combined
          
          expect(json_output['author'])
            .to eq 'Main Author,Co-Author 1,Co-Author 2'
        end
      end
    end

    describe 'publishing the journal title' do
      context 'when it is known' do
        it 'publishes the title of the journal' do
          a_row = a_row_with(journal: 'J. Phys. B')
          allow(@documents_combined).to receive(:read).and_return a_row

          json_output = @formatter.output_in @format, @documents_combined
      
          expect(json_output['journal']).to eq 'J. Phys. B'
        end
      end

      context 'when it is known' do
        it 'is left blank' do
          a_row = a_row_with(journal: nil)
          allow(@documents_combined).to receive(:read).and_return a_row
          
          json_output = @formatter.output_in @format, @documents_combined
          
          expect(json_output['journal']).to be_empty
        end
      end
    end

    it 'publishes the ISSN' do
      a_row = a_row_with(issn: '1234-5678')
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      
      output = @formatter.output_in(@format, @documents_combined)

      expect(output['issn']).to eq '1234-5678'
    end
  end

  describe 'CSV format' do
    it 'publishes the DOI in column 1' do
      a_row = a_row_with(doi: '10.1234/altmetric1')
      documents_combined = double(:documents_combined)
      allow(documents_combined).to receive(:read).and_return a_row
      
      csv_output = @formatter.output_in 'csv', documents_combined
      
      expect(csv_output).to have('10.1234/altmetric1').in_column 0
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
        message = "Expected #{csv_row.inspect} to have #{expected_field} "
        message << "at position #{@index}"

        message
      end
    end
  end

  def a_row_with(params)
    row = {
      doi: '10.1234/altmetric0', title: 'General Relativity',
      author: ['Albert Einstein'], journal: 'Nature',
      issn: '5432-8765'
    }
    row.merge params
  end
end
