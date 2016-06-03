class InFormat
  def initialize(format = 'json', document = [])
    @format = format
    @document = document
  end

  def output_in
    format_required =
        if @format == 'json'
          lambda { |row| as_json row }
        else
          lambda { |row| as_csv row }
        end

    @document.read.collect &format_required
  end

  def to_s
    output_in
  end

  private

  def as_csv row
    csv_row = [
        row[:doi], row[:title], comma_separated(row[:author]),
        row[:journal], row[:issn]
    ]

    csv_row
  end

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