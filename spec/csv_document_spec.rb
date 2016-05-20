require 'csv_document'
require 'doi_helper'
require 'issn_helper'
describe 'CSV Document' do
  include CreateDOI, CreateISSN

  describe '#content' do
    it 'stores the content as a CSV data structure' do
      article = {
          doi: DOI.new('10.1234/altmetric021'), title: 'R-Matrix Method',
          author: ['Author 1'], journal: 'Molecular Phys', issn: ISSN.new('8946-3422') }
      csv_doc = CSVDocument.new [article]

      expected = [
          DOI.new('10.1234/altmetric021'), 'R-Matrix Method',
          'Author 1', 'Molecular Phys', ISSN.new('8946-3422')
      ]
      expect(csv_doc.content).to include expected
      expect(csv_doc).not_to be_empty
    end

    context 'when an article has multiple authors' do
      it 'stores the authors as a comma-separated list' do
        article = {
            doi: a_doi,
            title: 'R-Matrix Method',
            author: ['Author 1', 'Co-Author 1', 'Co-Author 2' ],
            journal: 'Journal of Physics B',
            issn: an_issn

        }
        csv_doc = CSVDocument.new [ article ]

        expect(csv_doc.content[0][2]).to eq 'Author 1, Co-Author 1, Co-Author 2'
        expect(csv_doc).not_to be_empty
      end
    end
  end
end
