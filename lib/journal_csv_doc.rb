require 'forwardable'
require 'issn'
class JournalCSVDoc
  extend Forwardable
  def_delegator :@journals, :empty?

  def initialize(content = [])
    @journals = Hash[
        content.collect { |row| [ISSN.new(row[:issn]), row[:title]] }
    ]
  end

  def find issn
    @journals.fetch(issn, '')
  end

  def has_issn?(issn)
    @journals.has_key? issn
  end
end