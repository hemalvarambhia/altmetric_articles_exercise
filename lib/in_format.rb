require 'json'
require 'csv'
class InFormat
  def initialize(format = 'json', document = [])
    @format = format
    @document = document
  end

  def output_in
    if @format == 'json'
      return InJSONFormat.new(@document).output_in
    else
      return InCSVFormat.new(@document).output_in
    end
  end
end

class InJSONFormat
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

class InCSVFormat
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