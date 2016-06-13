require 'rspec'

describe 'A DOI' do
  class DOI
    attr_reader :code

    def initialize(code)
      raise Malformed.new(code) if code.nil?
      registry = code[0..2]
      raise Malformed.new(code) unless registry == '10.'
      separator = code.index('/')
      registrant = code[3..separator - 1]
      raise Malformed.new(code) if registrant.empty?
      item_id = code[separator + 1..-1]
      raise Malformed.new(code) if item_id.empty?
      @code = code
    end

    def ==(other)
      true
    end

    class Malformed < Exception
      def initialize(doi)
        super "DOI '#{doi}' is malformed"
      end
    end
  end

  context 'when it is blank' do
    it 'is malformed' do
      expect { DOI.new('') }.to raise_exception DOI::Malformed
      expect { DOI.new(nil) }.to raise_exception DOI::Malformed
    end
  end

  context "when the registry is '10.'" do
    it 'is well-formed' do
      expect { DOI.new('10.1234/altmetric032') }.not_to raise_exception
    end
  end

  context "when the registry is anything other than '10.'" do
    it 'is malformed' do
      expect { DOI.new('12.7658/altmetric244') }.to raise_exception DOI::Malformed
    end
  end

  context 'when it has no registrant' do
    it 'is malformed' do
      expect { DOI.new('10./altmetric546') }.to raise_exception DOI::Malformed
    end
  end

  context 'when the item ID is missing' do
    it 'is malformed' do
      expect { DOI.new('10.1234/') }.to raise_exception DOI::Malformed
    end
  end

  it 'stores the code passed to it' do
    doi = DOI.new '10.3444/altmetric0493'

    expect(doi.code).to eq '10.3444/altmetric0493'
  end


  describe '#==' do
    it 'is reflexive' do
      doi = DOI.new '10.74509/altmetric03234'

      expect(doi).to eq doi
    end

    it 'is symmetric' do
      doi_1 = DOI.new '10.5696/altmetric1983'
      doi_2 = DOI.new '10.5696/altmetric1983'

      expect(doi_1).to eq doi_2
      expect(doi_2).to eq doi_1
    end
  end
end