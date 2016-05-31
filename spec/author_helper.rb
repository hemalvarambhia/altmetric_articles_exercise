module CreateAuthor
  def authors
    some_authors = [
        'A Einstein', 'P A M Dirac', 'W Heisenberg', 'E Schrodinger',
        'M Born', 'W Pauli', 'M Planck'
    ]

    some_authors.sample(rand(0..some_authors.size))
  end
end