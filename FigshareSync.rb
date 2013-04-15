#!usr/bin/ruby

require 'oauth'
require 'json'

consumer = OAuth::Consumer.new('NXueJD2t1DMXN7cmBgmcnA','aNZEUQdeYpXWSsu0INnw7A',{:site=>"http://api.figshare.com"})
token = { :oauth_token => 'Ep6EHnBqnazUeeKfTQn9HwrC7mvfwynQHr00mAZo07iwEp6EHnXqnazUeeKfTQn9Hw',
          :oauth_token_secret => 'soPdczGixUt3JKEKw51AQA'
        }
client = OAuth::AccessToken.from_hash(consumer, token)

articlelist = client.get('/v1/my_data/articles')
#debug
puts (articlelist.body)

#Parse the article list and get values
parsed = JSON.parse(articlelist.body)
puts parsed.count
puts parsed['count']
i = 2#parsed['count']
puts i

i.times do#i should be replaced with parsed['count']
    |currentfile|
    inputfile = File.open ('file.example')#file.example should be replaced with local file
    filehash = OpenSSL::Digest.new('sha256', 'inputfile')
    puts "#{inputfile} has #{filehash.name} hash of #{filehash}"#debug
end