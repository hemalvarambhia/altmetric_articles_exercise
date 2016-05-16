require 'csv_document'
require 'doi_helper'
require 'issn_helper'
describe 'CSV Document' do
  include CreateDOI, CreateISSN

  it 'is initially empty' do
    csv_doc = CSVDocument.new

    expect(csv_doc).to be_empty
  end

  describe '#content' do
    it 'stores the content' do
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

  describe '#<<' do
    before(:each) { @doc = CSVDocument.new }

    it 'appends to the current content' do
      article = {
          doi: DOI.new('10.2344/altmetric023'), title: 'Quantum Mechanics',
          author: ['Physicist'], journal: 'Atomics', issn: ISSN.new('9784-1343') }

      @doc << article

      expected = [
          DOI.new('10.2344/altmetric023'), 'Quantum Mechanics',
          'Physicist', 'Atomics', ISSN.new('9784-1343')
      ]
      expect(@doc.content).to include expected
    end

    it 'appends in insertion order' do
      content = [
          { doi: DOI.new('10.3459/altmetric001'), title: 'Article 1',
            author: ['Author 1'], journal: 'Biology', issn: ISSN.new('5094-2131') },
          { doi: DOI.new('10.5345/altmetric333'), title: 'Article 2',
            author: ['Author 2'], journal: 'Maths', issn: ISSN.new('2453-3258') },
          { doi: DOI.new('10.5555/altmetric555'), title: 'Article 3',
            author: ['Author 3'], journal: 'Nanotech', issn: ISSN.new('9326-3111') }
      ]

      content.each { |element| @doc << element }

      expected = [
          [ DOI.new('10.3459/altmetric001'), 'Article 1',
            'Author 1', 'Biology', ISSN.new('5094-2131') ],
          [ DOI.new('10.5345/altmetric333'), 'Article 2',
            'Author 2', 'Maths', ISSN.new('2453-3258')  ],
          [ DOI.new('10.5555/altmetric555'), 'Article 3',
            'Author 3', 'Nanotech', ISSN.new('9326-3111') ]
      ]
      actual_content = @doc.content
      expected.each_with_index do |expected_csv, index|
        expect(actual_content[index]).to eq expected_csv
      end
    end
  end
end
