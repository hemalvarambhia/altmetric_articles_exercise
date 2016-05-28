describe 'Outputting combined documents' do
  class InFormat
    def output_in format, document
      {
        'doi' => document.read[:doi],
        'title' => document.read[:title],
        'author' => document.read[:author].to_s,
        'issn' => document.read[:issn]
      }
    end
  end

  describe 'JSON format' do
    before :each do
      @required_format = 'json'
      @documents_combined = double(:documents_combined)
      @formatter = InFormat.new
    end
    
    it 'publishes the DOI' do
      a_row = { doi: '10.1234/altmetric0', author: [] }
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      formatter = InFormat.new
      
      output = @formatter.output_in(@required_format, @documents_combined)

      expect(output['doi']).to eq '10.1234/altmetric0'
    end

    it 'publishes the title' do
      a_row = { title: 'The R-matrix Method' }
      allow(@documents_combined).to(receive(:read).and_return a_row)
      
      output = @formatter.output_in(@required_format, @documents_combined)

      expect(output['title']).to eq 'The R-matrix Method'
    end

    describe 'publishing the authors' do
      context 'when there is no author' do
        it 'publishes a blank' do
          no_author = nil
          a_row = { author: no_author }
          allow(@documents_combined).to(receive(:read).and_return a_row)
          
          json_output = @formatter.output_in @format, @documents_combined

          expect(json_output['author']).to be_empty
        end
      end
    end

    it 'publishes the ISSN' do
      a_row = { issn: '1234-5678' }
      allow(@documents_combined)
        .to receive(:read).and_return a_row
      
      output = @formatter.output_in(@required_format, @documents_combined)

      expect(output['issn']).to eq '1234-5678'
    end
  end
end
