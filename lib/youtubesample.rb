#!/usr/bin/ruby
require 'google/api_client'
require 'trollop'

# Set DEVELOPER_KEY to the "API key" value from the "Access" tab of the
# Google APIs Console <http://code.google.com/apis/console#access>
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = "AIzaSyAvAE2p-TTo1b4oSRCg4qzR5sE8o8c_8J8"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

opts = Trollop::options do
  opt :q, 'Search term', :type => String, :default => 'Silent Hall'
  opt :maxResults, 'Max results', :type => :int, :default => 25
end

client = Google::APIClient.new(key: DEVELOPER_KEY,
                               application_name: YOUTUBE_API_SERVICE_NAME,
                               application_version: YOUTUBE_API_VERSION, 
                               authorization: nil)
youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

opts[:part] = 'id,snippet'
search_response = client.execute!(
  :api_method => youtube.search.list,
  :parameters => opts
)

videos = []
channels = []
playlists = []

search_response.data.items.each do |search_result|
  case search_result.id.kind
    when 'youtube#video'
      videos.push("#{search_result.snippet.title} (#{search_result.id.videoId})")
    when 'youtube#channel'
      channels.push("#{search_result.snippet.title} (#{search_result.id.channelId})")
    when 'youtube#playlist'
      playlists.push("#{search_result.snippet.title} (#{search_result.id.playlistId})")
  end
end

puts "Videos:\n", videos, "\n"
puts "Channels:\n", channels, "\n"
puts "Playlists:\n", playlists, "\n"
