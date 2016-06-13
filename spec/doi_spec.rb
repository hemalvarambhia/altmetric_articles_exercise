require 'rspec'

describe 'A DOI' do
  class DOI
    Malformed = Class.new(Exception)

    def initialize(code)
      registry = code[0..2]
      raise Malformed.new("DOI '#{code}' is malformed") unless registry == '10.'
      separator = code.index('/')
      registrant = code[3..separator - 1]
      raise Malformed.new("DOI '#{code}' is malformed") if registrant.empty?
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
end