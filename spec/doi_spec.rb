require 'rspec'

describe 'A DOI' do
  class DOI
    Malformed = Class.new(Exception)

    def initialize(code)
      raise Malformed.new("DOI '#{code}' is malformed") if code.empty?
    end
  end

  context 'when it is blank' do
    it 'is malformed' do
      expect { DOI.new('') }.to raise_exception DOI::Malformed
    end
  end

  context "when it starts with '10.'" do
    it 'is well-formed' do
      expect { DOI.new('10.1234/altmetric032') }.not_to raise_exception
    end
  end
end