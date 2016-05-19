require 'csv'
require 'document'
class CSVDocument < Document
  def content
    @content.collect do |article|
      [
          article[:doi],
          article[:title],
          article[:author].join(', '),
          article[:journal],
          article[:issn]
      ]
    end
  end

  def to_s
    CSV.generate do |csv|
      content.each { |row| csv << row }
    end
  end
end

