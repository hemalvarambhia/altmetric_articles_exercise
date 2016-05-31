module ISSN
  def correct_issn(issn)
    dash_absent = issn.scan(/-/).none?
    corrected = dash_absent ? issn.insert(4, '-') : issn

    corrected
  end
end
