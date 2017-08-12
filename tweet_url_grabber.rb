require 'rubygems'
require 'twitter'
require 'yaml'

#sets the directory to c drive, and then for there to rubystuff folder
Dir.chdir "c:/"
Dir.chdir "users/shen/desktop/rubystuff"


#Twitter authentication stuff **--REMEMBER TO DELETE YOUR DETAILS IF YOU MAKE PUBLIC--**
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
 end

#get the time limit for 24 hours before the time of search and convert it to string 
yesterday_time = Time.now.utc - (60*60*24)
search_date_limit = yesterday_time.to_date.to_s

#set up an array to collect the tweets from the search
todays_pixelart_tweets = []

#set the search operators. These are regular search operators that can be used within Twitter itself. 
pixel_art_tweets = client.search("#pixelart AND filter:images AND -filter:retweets AND -filter:replies AND since:#{search_date_limit}")

#for each tweet in previous search, make sure it has media, make sure that media is a pic and make sure it was created by the ime set previously.
pixel_art_tweets.each do |tweet|
	if tweet.media? && tweet.media[0].attrs[:type] == "photo" && tweet.created_at.dup.utc > yesterday_time
		todays_pixelart_tweets.push(tweet)
	end
end

#sort the resulting tweet array by number favorite count
sorted_tweets = todays_pixelart_tweets.sort_by do |tweet|
	tweet.favorite_count
end
#the sorted array will be in ascending order, so reverse it to get most-liked tweet at the top
reverse_sorted_tweets = sorted_tweets.reverse
#take the top tweet and print out its url
puts reverse_sorted_tweets[0].url
	

#extra code to log how many requests you have before and after each request. You put the BEFORE bit before request, AFTER bit goes afterwards:	
=begin
puts "----------BEFORE:----------"
limit = Twitter::REST::Request.new(client, :get, "/1.1/application/rate_limit_status.json").perform
puts limit[:resources][:search][:"/search/tweets"][:remaining]
puts "---------------------------"

puts "----------AFTER-------------------"
after_limit = Twitter::REST::Request.new(client, :get, "/1.1/application/rate_limit_status.json").perform
puts after_limit[:resources][:search][:"/search/tweets"][:remaining]	
puts "---------------------------"
=end