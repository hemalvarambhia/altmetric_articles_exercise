#!/bin/bash

ruby combine.rb --format json journals.csv articles.csv authors.json > full_articles.json
 
diff expected_full_articles.json full_articles.json
if [ $? -eq 0 ]; then
  echo 'Passed' 
else
  echo 'Failed'
fi
