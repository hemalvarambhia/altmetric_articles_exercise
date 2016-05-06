class Article
  def initialize(args)
    @doi = args[:doi]
    @issn = args[:issn]
    @title = args[:title]
    @journal = args[:journal]
    @author = args.fetch(:authors, [])
  end

  def as_json
    { 
      'doi' => @doi, 
      'title' => @title,
      'author' => @author.join(','),
      'journal' => @journal,
      'issn' => @issn
    }
  end

  def as_csv
    [ @doi, @title, @author.join(','), @journal, @issn ]
  end
end

