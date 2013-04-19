#!/usr/bin/ruby

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
    
    def populate
        @views
        @downloads
        @shares
        @handleurl
        @status
        @publishdata
        @totalsize
        @owner
        @authors
        @tags
        @categories
        @files
    end