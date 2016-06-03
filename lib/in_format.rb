require 'json'
require 'csv'
class InFormat
  def self.output(format, document)
    if format == 'json'
      return JSONFormat.new(document)
    else
      return CSVFormat.new(document)
    end
  end

  class JSONFormat
    def initialize(document)
      @document = document
    end

    def output_in
      @document.read.collect { |row| as_json row }
    end

    def to_s
      JSON.pretty_generate(output_in)
    end

    private

    def as_json row
      {
      'doi' => row[:doi],
      'title' => row[:title],
      'author' => comma_separated(row[:author]),
      'journal' => row[:journal],
      'issn' => row[:issn]
      }
    end

    def comma_separated authors
      authors.join(',')
    end
  end

  class CSVFormat
    def initialize(document)
      @document = document
    end

    def output_in
      @document.read.collect { |row| as_csv row }
    end

    def to_s
      CSV.generate do |csv|
        output_in.each do |row|
          csv << row
        end
      end
    end

    private

    def as_csv row
      csv_row = [
          row[:doi], row[:title], comma_separated(row[:author]),
          row[:journal], row[:issn]
      ]

      csv_row
    end

    def comma_separated authors
      authors.join(',')
    end
  end
end


