require 'json'
class AuthorJSONDoc
  def initialize(io)
    @io = io
  end

  def read
    JSON.parse(@io.read)
  end
end
