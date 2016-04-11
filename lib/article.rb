require 'issn'
require 'journal'
class Article
  extend Forwardable

  attr_reader :doi, :title, :author
  def_delegator :@journal, :issn

  def initialize(args)
    @doi = args[:doi]
    @title = args[:title]
    @author = args[:author] || []
    @journal = args[:journal] || Journal.new('', nil)
  end

  def journal
    @journal.title
  end

  def ==(other)
    doi == other.doi
  end
end
