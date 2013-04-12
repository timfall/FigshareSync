require 'oath'
require 'json'

consumer = OAuth::Consumer.new('key','secret',{:site=>"http://api.figshare.com"})
token = { :oauth_token => 'Ep6EHnBqnazUeeKfTQn9HwrC7mvfwynQHr00mAZo07iwEp6EHnXqnazUeeKfTQn9Hw',
          :oauth_token_secret => 'soPdczGixUt3JKEKw51AQA'
        }
client = OAuth::AccessToken.from_hash(consumer, token)

articlelist = client.get('/v1/my_data/articles')
#debug
print articlelist.body

#Parse the article list and get values
parsed = JSON.parse(articlelist)
articlecount = parsed.count