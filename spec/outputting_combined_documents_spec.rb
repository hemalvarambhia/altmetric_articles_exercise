describe 'Outputting combined documents' do
  class InFormat
    def output_in format, document
      format_required =
        if format == 'json'
          lambda { |row| as_json row }
        else
          lambda { |row| as_csv row }
        end

      document.read.collect &format_required
    end

    private

    def as_csv row
      csv_row = [
        row[:doi], row[:title], comma_separated(row[:author]),
        row[:journal].to_s, row[:issn]
      ]

      csv_row
    end

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

  before(:each) do
    @formatter = InFormat.new
    @documents_combined = double(:documents_combined)
  end

  describe 'JSON format' do
    before :each do
      @format = 'json'
    end
    
    it 'publishes the DOI' do
      a_row = a_row_with({ doi: '10.1234/altmetric0' })
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      
      json_output = generate_output

      expect(json_output['doi']).to eq '10.1234/altmetric0'
    end

    it 'publishes the title' do
      a_row = a_row_with(title: 'The R-matrix Method')
      allow(@documents_combined).to(receive(:read).and_return a_row)
      
      json_output = generate_output

      expect(json_output['title']).to eq 'The R-matrix Method'
    end

    describe 'publishing the author' do
      context 'when there is none' do
        it 'publishes a blank' do
          no_author = []
          a_row = a_row_with(author: no_author)
          allow(@documents_combined).to(receive(:read).and_return a_row)
          
          json_output = generate_output

          expect(json_output['author']).to be_empty
        end
      end

      context 'when there is a single author' do
        it 'publishes their name' do
          a_row = a_row_with(author: [ 'Physicist' ])
          allow(@documents_combined).to(receive(:read).and_return a_row) 
          
          json_output = generate_output
          
          expect(json_output['author']).to eq 'Physicist'
        end
      end

      context 'when there is more than 1 author' do
        it 'publishes their names separated by a comma' do
          a_row = a_row_with(
            author: ['Main Author', 'Co-Author 1', 'Co-Author 2'])
          allow(@documents_combined).to(receive(:read).and_return a_row)

          json_output = generate_output

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

          json_output = generate_output

          expect(json_output['journal']).to eq 'J. Phys. B'
        end
      end

      context 'when it is not known' do
        it 'is left blank' do
          a_row = a_row_with(journal: nil)
          allow(@documents_combined).to receive(:read).and_return a_row
          
          json_output = generate_output
          
          expect(json_output['journal']).to be_empty
        end
      end
    end

    it 'publishes the ISSN' do
      a_row = a_row_with(issn: '1234-5678')
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      
      json_output = generate_output

      expect(json_output['issn']).to eq '1234-5678'
    end
  end

  describe 'CSV format' do
    before(:each) { @format = 'csv' }
    
    it 'publishes the DOI in column 1' do
      a_row = a_row_with(doi: '10.1234/altmetric1')
      allow(@documents_combined).to receive(:read).and_return a_row
      
      csv_output = generate_output
      
      expect(csv_output).to have('10.1234/altmetric1').in_column 0
    end

    it 'publishes the title in column 2' do
      a_row = a_row_with(title: 'R-Matrix Method')
      allow(@documents_combined).to receive(:read).and_return a_row
      
      csv_output = generate_output

      expect(csv_output).to have('R-Matrix Method').in_column 1
    end

    describe 'publishing authors' do
      context 'given the article has only a single author' do
        it 'publishes the author in column 3' do
          a_row = a_row_with(author: [ 'Paul Dirac' ])
          allow(@documents_combined).to receive(:read).and_return a_row
      
          csv_output = generate_output
          
          expect(csv_output).to have('Paul Dirac').in_column 2
        end
      end

      context 'given the article has multiple authors' do
        it 'publishes their names comma-separated in column 3' do
          a_row = a_row_with(author: ['P Dirac', 'M Born', 'W Heisenberg'])
          allow(@documents_combined).to receive(:read).and_return a_row
          
          csv_output = generate_output
          
          expect(csv_output)
            .to have('P Dirac,M Born,W Heisenberg').in_column 2
        end
      end
    end

    describe 'publishing the journal title' do
      context 'when it is known' do
         it 'publishes the journal title in column 4' do
           a_row = a_row_with(journal: 'Nature')
           allow(@documents_combined).to receive(:read).and_return a_row
          
           csv_output = generate_output
          
           expect(csv_output).to have('Nature').in_column 3
         end
      end

      context 'when it is not known' do
         it 'publishes a blank title in column 4' do
           a_row = a_row_with(journal: nil)
           allow(@documents_combined).to receive(:read).and_return a_row
          
           csv_output = generate_output
          
           expect(csv_output).to have('').in_column 3
         end
      end
    end

    it 'publishes the ISSN in column 5' do
      a_row = a_row_with(issn: '1234-5678')
      allow(@documents_combined).to receive(:read).and_return a_row
      
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
    allow(@documents_combined).to receive(:read).and_return content

    csv_output = @formatter.output_in format, @documents_combined

    expect(csv_output.size).to eq content.size
  end
  
  def generate_output
    @formatter.output_in(@format, @documents_combined).first
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

  def authors
    [
      'A Einstein', 'P A M Dirac', 'W Heisenberg', 'E Schrodinger',
      'M Born', 'W Pauli', 'M Planck'
    ].sample(rand(0..4))
  end

  def generate_doi
    registrant = Array.new(4) { rand(0..9) }.join
    "10.#{registrant}/altmetric#{rand(100000000)}"
  end

  def generate_issn
    digits = Array.new(8) { rand(0..9) }
    "#{digits[0..3].join}-#{digits[4..-1].join}"
  end  
end
