require 'oath'
require 'json'

consumer = OAuth::Consumer.new('123456','65xyAzi1',{:site=>"http://api.figshare.com"})
token = { :oauth_token => 'Ep6EHnBqnazUeeKfTQn9HwrC7mvfwynQHr00mAZo07iwEp6EHnXqnazUeeKfTQn9Hw',
          :oauth_token_secret => 'soPdczGixUt3JKEKw51AQA'
        }
client = OAuth::AccessToken.from_hash(consumer, token)