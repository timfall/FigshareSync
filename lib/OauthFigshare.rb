#!/usr/bin/ruby

require 'oauth'

class OauthFigshare < OAuth::AccessToken
    def self.new (consumerkey, consumersecret, accesstoken, accesstokensecret)
        @consumerkey = consumerkey
        @consumersecret = consumersecret
        @accesstoken = accesstoken
        @accesstokensecret = accesstokensecret
        @apiurl = "http://api.figshare.com"
        
        @consumer = OAuth::Consumer.new(@consumerkey,@consumersecret,{:site=> @apiurl})
        @token = { :oauth_token => @accesstoken,:oauth_token_secret => @accesstokensecret}
        
        @client = OAuth::AccessToken.from_hash(@consumer, @token)
    end
end