#!/usr/bin/ruby

require 'json'
require 'oauth'
require './lib/OauthFigshare'
require './lib/FigshareClasses'

workingdir = "~/465375/.figsharesync/"#Cloud 9 specific workaround for user directory
consumerkey = nil
consumersecret = nil
accesstoken = nil
accesstokensecret = nil
localarticlelist = nil

#First run setup
puts workingdir#debug
absworkingdir = File.expand_path(workingdir)
puts absworkingdir#debug
puts File.exist?("#{absworkingdir}/FirstRun.lock")#debug
puts File.exist?("~/FirstRun.lock")#debug
if File.exist?("#{absworkingdir}/FirstRun.lock") == false
    puts "This appears to be the first run of FigShare Sync. We'll setup a few things."
	print "Where would you like to store settings and files? [~./figsharesync]: "
	@input = gets.chomp
    puts @input#debug
		if @input.empty? == false
			workingdir = @input
			absworkingdir = File.expand_path(workingdir)
            Dir.mkdir(absworkingdir) if Dir.exists?(absworkingdir) == false
		end
	print "Please enter OAuth consumer key: "
	consumerkey = gets.chomp
	print "Please enter OAuth consumer key secret: "
	consumersecret = gets.chomp
	print "Please enter OAuth access token: "
	accesstoken = gets.chomp
	print "Please enter OAuth access token secret: "
	accesstokensecret = gets.chomp
	puts "Great! we'll get running now..."
    puts absworkingdir#debug
    Dir.mkdir(absworkingdir) if Dir.exists?(absworkingdir) == false
    Dir.mkdir("#{absworkingdir}/oauth") if Dir.exists?("#{absworkingdir}/oauth") == false
    File.open("#{absworkingdir}/oauth/tokens.oauth", "w") {|file|
        file.write ("#{consumerkey}\n")
        file.write ("#{consumersecret}\n")
        file.write ("#{accesstoken}\n")
        file.write ("#{accesstokensecret}\n")
        file.close
    }
	File.open("#{absworkingdir}/FirstRun.lock", "w"){}
end
#oauth authenticate
@oauthvariables
File.open("#{absworkingdir}/oauth/tokens.oauth", "r+") {|file|
        @oauthvariables = file.readlines
        file.close
    }
consumerkey = @oauthvariables[0].chomp
consumersecret = @oauthvariables[1].chomp
accesstoken = @oauthvariables[2].chomp
accesstokensecret = @oauthvariables[3].chomp

auth = OauthFigshare.new(consumerkey, consumersecret, accesstoken, accesstokensecret)
puts consumerkey#debug
puts consumersecret#debug
puts accesstoken#debug
puts accesstokensecret#debug
puts auth#debug
	articleresponse = auth.get('/v1/my_data/articles')
    if articleresponse.header == Net::HTTPUnauthorized
		puts "Figshare returned #{articleresponse.header (v1/my_data/articles)}"
	end
puts articleresponse.header#debug
puts "Successfully authenticated"

#Create article database and populate from local sources
File.exists?("#{absworkingdir}/localdb.json") {
	puts "Local database detected, populating from there"
	ldb = JSON.parse("#{absworkingdir}/localdb.json")
	@i = ldb['count']
	@i.times do
		localarticlelist[i] = Article.new(ldb[i].name, "#{absworkingdir}/localdb/#{ldb[i].name}", ldb[i].id, ldb[i].title, ldb[i].description, ldb[i].defined_type)
	end
	puts "Done populating the local list from local database"
}
	puts "No local database detected, grabbing one from the server"
	ldb = auth.get('/v1/my_data/articles')
	ldb = JSON.parse(ldb.body)
	@local = File.new("#{absworkingdir}/localdb.json", "w")
	@local << ldb
	i = ldb['count']
	i.times do
		localarticlelist[i] = Article.new(ldb[i].name, "#{absworkingdir}/localdb/#{ldb[i].name}", ldb[i].id, ldb[i].title, ldb[i].description, ldb[i].defined_type)
	end
	puts "Local database file created and populated from server"

#Compare local and remote databses for differences
rdb = auth.get('v1/my_data/articles')
rdb = JSON.parse(rdb.body)
i = rdb['count']
r = ldb['count']
i.times do
	remotearticlelist[i] = Article.new(rdb[i].name, "/v1/my_data/articles/#{ldb[i].name}", rdb[i].id, rdb[i].title, rdb[i].description, rdb[i].defined_type)
end
i.times do
    r.times do
	@remotehash = remotearticlelist[i].hash
	@localhash = localarticlelist[r].hash
	if rdb[i].id == ldb[r].id
		if @remotehash != @localhash
			puts "Hash mismatch! #{remotearticlelist[i].name} and #{localarticlelist[r].name} do not match"
			if File.mtime(remotearticlelist[i].path) >= File.mtime(localarticlelist[r].path)#If remote version is newer than local
				File.new('#{absworkingdir}/localdb/#{remotearticlelist[i].name}', "w") {|file| file.write(auth.get(remotearticlelist[i].path))}#download remote version
				localarticlelist[r] = Article.new(rdb[i].name, "#{absworkingdir}/localdb/#{rbd[i].name}", rbd[i].id)#create new local article entry
				download = auth.get(remotearticlelist[i].path)
				download = JSON.parse(download.body)
				@local = File.read("#{absworkingdir}/localdb.json")
				#@local.gsub(/pattern/) { matchmatchmatch } #replace entry in localdb.json
			elsif File.mtime(remotearticlelist[i].path) <= File.mtime(localarticlelist[r].path)#If local version is newer than remote
				localfile = JSON.pretty_generate('Title' => localarticlelist[r].title, 'description' => localarticlelist[r].description, 'defined_type' => localarticlelist[r].defined_type)#generate a json list from the object
				auth.post('v1/my_data/articles/', localfile, {"Content-Type" => "application/json"})#upload json list
			end
		end
	end
	next
	end
end
puts "All hashes match"