#!/bin/bash

#!/bin/bash

ruby combine.rb --format json files_with_one_item/one_journal.csv files_with_one_item/one_article.csv files_with_one_item/one_author.json > full_articles.json
 
diff expected_merged_article.json full_articles.json
if [ $? -eq 0 ]; then
  echo 'Passed' 
else
  echo 'Failed'
fi
