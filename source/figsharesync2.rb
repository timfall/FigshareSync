#!/usr/bin/ruby

require 'json'
require 'oauth'
require '../lib/OauthFigsharesync'
require '../lib/FigshareClasses'

workingdir = "~/.figsharesync/"
consumerkey
consumersecret
accesstoken
accesstokensecret
localarticlelist

#First run setup
absworkingdir = File.expand_path(workingdir)
if File.exist?("#{absworkingdir}/FirstRun.lock")
  break
else
    puts "This appears to be the first run of FigShare Sync. We'll setup a few things."
	print "Where would you like to store settings and files? [~./figsharesync]: "
	@input = gets.chomp
		if @input != nil
			workingdir = @input
			absworkingdir = File.expand_path(workingdir)
		else
			break
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
	File.new("#{absworkingdir}/FirstRun.lock", "r")
end
#oauth authenticate
auth = OauthFighshare.new(consumerkey, consumersecret, accesstoken, accesstokensecret)
	if auth.header (v1/my_data/articles) == Net::HTTPUnauthorized
		puts "Figshare returned #{auth.header (v1/my_data/articles)}"
	end
puts "Successfully authenticated"

#Create article database and populate from local sources
if File.exists?("#{absworkingdir}/localdb.json") then
	puts "Local database detected, populating from there"
	ldb = JSON.parse("#{absworkingdir}/localdb.json")
	@i = ldb['count']
	for @i.times do
		localarticlelist[i] = Article.new(ldb[i].name, "#{absworkingdir}/localdb/#{ldb[i].name}", ldb[i].id, ldb[i].title, ldb[i].description, ldb[i].defined_type)
	done
	puts "Done populating the local list from local database"
end
else
	puts "No local database detected, grabbing one from the server"
	ldb = auth.get('v1/my_data/articles')
	ldb = JSON.parse(ldb.body)
	@local = File.new("#{absworkingdir}/localdb.json", "w")
	@local << ldb
	i = ldb['count']
	for i.times do
		localarticlelist[i] = Article.new(ldb[i].name, "#{absworkingdir}/localdb/#{ldb[i].name}", ldb[i].id, ldb[i].title, ldb[i].description, ldb[i].defined_type)
	done
	puts "Local database file created and populated from server"
end

#Compare local and remote databses for differences
rdb = auth.get('v1/my_data/articles')
rdb = JSON.parse(rdb.body)
i = rdb[count]
r = ldb[count]
for i.times do
	remotearticlelist[i] = Article.new(rdb[i].name, "v1/my_data/articles/#{ldb[i].name}", rdb[i].id, rdb[i].title, rdb[i].description, rdb[i].defined_type)
done
for i.times do
	for r.times do
	@remotehash = remotearticlelist[i].hash
	@localhash = localarticlelist[r].hash
	if rdb[i].id == ldb[r].id
		if @remotehash != @localhash
			puts "Hash mismatch! #{remotearticlelist[i].name} and #{localarticlelist[r].name} do not match"
			if File.mtime(remotearticlelist[i].path) >= File.mtime(localarticlelist[r].path) then#If remote version is newer than local
				File.new('#{absworkingdir}/localdb/#{remotearticlelist[i].name}', "w") = auth.get(remotearticlelist[i].path)#download remote version
				localarticlelist[r] = Article.new(rdb[i].name, "#{absworkingdir}/localdb/#{rbd[i].name}", rbd[i].id)#create new local article entry
				download = auth.get(remotearticlelist[i].path)
				download = JSON.parse(download.body)
				@local = File.read("#{absworkingdir}/localdb.json")
				@local.gsub(/pattern/) { matchmatchmatch } #replace entry in localdb.json
			end
			elsif File.mtime(remotearticlelist[i].path) <= File.mtime(localarticlelist[r].path)#If local version is newer than remote
				localfile = JSON.pretty_generate('Title' => localarticlelist[r].title, 'description' => localarticlelist[r].description, 'defined_type' => localarticlelist[r].defined_type)#generate a json list from the object
				auth.post('v1/my_data/articles/', localfile, {"Content-Type" => "application/json"})#upload json list
			end
		end
	end
	next
	done
done
puts "All hashes match"