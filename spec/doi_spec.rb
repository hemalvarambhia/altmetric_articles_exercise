require 'rspec'

describe 'A DOI' do
  class DOI
    Malformed = Class.new(Exception)
    attr_reader :code

    def initialize(code)
      registry = code[0..2]
      raise Malformed.new("DOI '#{code}' is malformed") unless registry == '10.'
      separator = code.index('/')
      registrant = code[3..separator - 1]
      raise Malformed.new("DOI '#{code}' is malformed") if registrant.empty?
      item_id = code[separator + 1..-1]
      raise Malformed.new("DOI '#{code}' is malformed") if item_id.empty?
      @code = code
    end
  end

  context 'when it is blank' do
    it 'is malformed' do
      expect { DOI.new('') }.to raise_exception DOI::Malformed
    end
  end

  context "when it has a registry that is '10.'" do
    it 'is well-formed' do
      expect { DOI.new('10.1234/altmetric032') }.not_to raise_exception
    end
  end

  context "when it has a registry that is anything other than '10.'" do
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
end