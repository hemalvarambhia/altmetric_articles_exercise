require 'rspec'

describe 'A DOI' do
  class DOI
    Malformed = Class.new(Exception)

    def initialize(code)
      raise Malformed.new("DOI '#{code}' is malformed")
    end
  end
  context 'when it is blank' do
    it 'is malformed' do
      expect { DOI.new('') }.to raise_exception DOI::Malformed
    end
  end
end