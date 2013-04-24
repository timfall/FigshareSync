#!/usr/bin/ruby

require 'json'
require 'oauth'

class Article
    def initialize (name, localpath, id, title, description, defined_type)
        @name = name
        @path = localpath
        @id = id
        @title = title
        @description = description
        @defined_type = defined_type
    end
    
    def hash
        inputfile = File.open ('path')
        filehash = OpenSSL::Digest.new('sha256', 'inputfile')
        puts "#{inputfile.path} has #{filehash.name} hash of #{filehash}"#debug
        return filehash
    end
    
    def populate (authtoken)
        form = authtoken.get ('/v1/my_data/articles/#{@id}')
        form = JSON.parse(form.body)
        @views = form['views']
        @downloads = form['downloads']
        @shares = form['shares']
        @handleurl = form['handle_url']
        @status = form['status']
        @publisheddata = form['published_data']
        @totalsize = form['total_size']
        @owner = form['owners']
        @authors = form['authors']
        @tags = form['tags']
        @categories = form['categories']
        @files = form['files']
    end
end
    
class ArticleDatabase
    def initialize (count, authtoken, localpath)
        db = authtoken.get ('/v1/my_data/articles')
        db = JSON.parse (db.body)
        articledatabase
        db[:item].each_object do |article_id|
            articledatabase[article_id] = Article.new(db[:item]['name'], '#{localpath}/localdb/#{article_id}', db[:item]['article_id'], db[:item]['title'], db[:item]['description'], db[:item]['defined_type'])#create new article entry for each article listed
            aritcledatabase[article_id].populate(authtoken)
        end
        return articledatabase
    end
end