require 'oauth'
require 'json'

consumer = OAuth::Consumer.new('NXueJD2t1DMXN7cmBgmcnA','aNZEUQdeYpXWSsu0INnw7A',{:site=>"http://api.figshare.com"})
token = { :oauth_token => 'Ep6EHnBqnazUeeKfTQn9HwrC7mvfwynQHr00mAZo07iwEp6EHnXqnazUeeKfTQn9Hw',
          :oauth_token_secret => 'soPdczGixUt3JKEKw51AQA'
        }
client = OAuth::AccessToken.from_hash(consumer, token)

result = client.get('/v1/my_data/articles')
#debug
puts (result.body)

#Parse the article list and get values
parsed = JSON.parse(result.body)
puts parsed.count