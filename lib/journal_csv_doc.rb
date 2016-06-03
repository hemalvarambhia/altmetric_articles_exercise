require 'forwardable'
require 'issn'
class JournalCSVDoc
  extend Forwardable
  include ISSN
  def_delegator :@journals, :empty?

  def initialize(content = [])
    @journals = Hash[
        content.collect { |row| [correct_issn(row[:issn]), row[:title]] }
    ]
  end

  def find issn
    @journals.fetch(issn, '')
  end

  def has_issn?(issn)
    @journals.has_key? issn
  end
end