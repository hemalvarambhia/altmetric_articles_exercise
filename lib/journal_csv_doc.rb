require 'csv'
class JournalCSVDoc
  def initialize(io)
    @io = CSV.new(io, {headers: true})
  end

  def read
    @io.read[0]
  end
end
