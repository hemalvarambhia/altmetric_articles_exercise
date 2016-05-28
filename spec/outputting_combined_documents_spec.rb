describe 'Outputting combined documents' do
  class InFormat
    def output_in format, document
      {
        'doi' => document.read[:doi],
        'title' => document.read[:title],
        'author' => comma_separated(document.read[:author]),
        'journal' => document.read[:journal].to_s,
        'issn' => document.read[:issn]
      }
    end

    private

    def comma_separated authors
      authors.join(',')
    end
  end

  describe 'JSON format' do
    before :each do
      @required_format = 'json'
      @documents_combined = double(:documents_combined)
      @formatter = InFormat.new
    end
    
    it 'publishes the DOI' do
      a_row = a_row_with({ doi: '10.1234/altmetric0' })
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      formatter = InFormat.new
      
      output = @formatter.output_in(@required_format, @documents_combined)

      expect(output['doi']).to eq '10.1234/altmetric0'
    end

    it 'publishes the title' do
      a_row = { title: 'The R-matrix Method', author: [] }
      allow(@documents_combined).to(receive(:read).and_return a_row)
      
      output = @formatter.output_in(@required_format, @documents_combined)

      expect(output['title']).to eq 'The R-matrix Method'
    end

    describe 'publishing the author' do
      context 'when there is none' do
        it 'publishes a blank' do
          no_author = []
          a_row = { author: no_author }
          allow(@documents_combined).to(receive(:read).and_return a_row)
          
          json_output = @formatter.output_in @format, @documents_combined

          expect(json_output['author']).to be_empty
        end
      end

      context 'when there is a single author' do
        it 'publishes their name' do
          a_row = { author: [ 'Physicist' ] }
          allow(@documents_combined)
            .to(receive(:read).and_return a_row) 
          
          json_output = @formatter.output_in @format, @documents_combined
          
          expect(json_output['author']).to eq 'Physicist'
        end
      end

      context 'when there is more than 1 author' do
        it 'publishes their names separated by a comma' do
          a_row = { author: ['Main Author', 'Co-Author 1', 'Co-Author 2']}
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
          a_row = { journal: 'J. Phys. B', author: [] }
          allow(@documents_combined).to receive(:read).and_return a_row

          json_output = @formatter.output_in @format, @documents_combined
      
          expect(json_output['journal']).to eq 'J. Phys. B'
        end
      end

      context 'when it is known' do
        it 'is left blank' do
          a_row = { journal: nil, author: [] }
          allow(@documents_combined).to receive(:read).and_return a_row
          
          json_output = @formatter.output_in @format, @documents_combined
          
          expect(json_output['journal']).to be_empty
        end
      end
    end

    it 'publishes the ISSN' do
      a_row = { issn: '1234-5678', author: [] }
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      
      output = @formatter.output_in(@required_format, @documents_combined)

      expect(output['issn']).to eq '1234-5678'
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
