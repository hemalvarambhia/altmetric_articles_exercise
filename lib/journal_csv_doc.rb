require 'forwardable'
require 'issn'
class JournalCSVDoc
  extend Forwardable
  include ISSN
  def_delegator :@journals, :empty?

  def initialize(content = [])
    @journals = Hash[
        content.collect { |title, issn| [correct_issn(issn), title] }
    ]
  end

  def find issn
    @journals.fetch(issn, '')
  end

  def has_issn?(issn)
    @journals.has_key? issn
  end
end