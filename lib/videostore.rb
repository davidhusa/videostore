require 'faraday'
require 'google/api_client'
require 'vimeo'
begin
  load 'keys.rb' ## store your youtube API key here as the constant YOUTUBE_DEVELOPER_KEY
rescue LoadError
  raise "To start using the gem have a file to the lib directory called keys.rb " << 
        "that defines YOUTUBE_DEVELOPER_KEY as your google developer key (must have access to the V3 Youtube API)."
end

module VideoStore
  class Video
    attr_accessor :video_id
    attr_reader :title, :thumbnail_uri, :channel_name, :views, 
                :likes, :comment_count, :duration
    ATTRIBUTES = :video_id, :title, :thumbnail_uri, :channel_name, :views,
                 :likes, :comment_count, :duration

    def initialize
      raise NoMethodError
    end
  end

  class Youtube < Video
    DEVELOPER_KEY = ::YOUTUBE_DEVELOPER_KEY
    YOUTUBE_API_SERVICE_NAME = "youtube"
    YOUTUBE_API_VERSION = "v3"

    class << self
      def establish_connection
        @client = Google::APIClient.new(key: DEVELOPER_KEY,
                                        application_name: YOUTUBE_API_SERVICE_NAME,
                                        application_version: YOUTUBE_API_VERSION, 
                                        authorization: nil)
        @connection = @client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
      end
      def connection
        @connection
      end
      def client
        @client
      end 
    end # end of class methods
    establish_connection

    def initialize(video_id)
      @video_id = video_id
      @response_hash = Hash.new
      populate_attributes
    end

    def connection
      self.class.connection
    end
    def client
      self.class.client
    end 

    def present?(options = {})
      JSON.parse(fetch_data('id').response.body)["pageInfo"]["totalResults"] == 1
    end
  
    def populate_attributes(options = {})
      if present?
        content_details = JSON.parse(fetch_data('contentDetails').response.body)['items'].first['contentDetails']
        @duration = content_details["duration"].youtube_duration_to_seconds

        statistics = JSON.parse(fetch_data('statistics').response.body)['items'].first['statistics']
        @views = statistics["viewCount"].to_i
        @likes = statistics["likeCount"].to_i
        @comment_count = statistics["commentCount"].to_i

        snippet = JSON.parse(fetch_data('snippet').response.body)['items'].first['snippet']
        @title = snippet["title"]
        @thumbnail_uri = snippet["thumbnails"]["default"]["url"]
        @channel_name = snippet["channelTitle"]
      end
      info
    end

    def uri
      "http://www.youtube.com/watch?v=#{@video_id}" if present?
    end

    def info
      response = {}
      if present?
        ATTRIBUTES.each do |attribute|
          response.merge!({attribute => send(attribute)})
        end
      else
        response.merge!({:video_id => @video_id})
        response.merge!({:video_not_found => 'video_not_found'})
      end 
      response
    end

    def youtube? ; true ; end
    def vimeo? ; false ; end

    private

    def fetch_data(part, options = {})
      if options[:use_cache] && @response_hash[part]
        @response_hash[part]
      else
        @response_hash[part] = client.execute!(
          :api_method => connection.videos.list,
          :parameters => {
            :id => @video_id,
            :part => part,
          }
        )
      end
    end

  end # end of Youtube class

  class Vimeo < Video
    def initialize(video_id) 
      @video_id = video_id
      populate_attributes
    end

    def present?
      ::Vimeo::Simple::Video.info(@video_id
        ).parsed_response.class == Array
    end

    def uri
      "http:://vimeo.com/#{@video_id}"
    end

    def populate_attributes
      if present?
        fetch_data

        @title =  @response['title']
        @thumbnail_uri =  @response['thumbnail_large']
        @channel_name =  @response['user_name']
        @views =  @response['stats_number_of_plays']
        @likes =  @response['stats_number_of_likes']
        @comment_count =  @response['stats_number_of_comments']
        @duration =  @response['duration']
      end
    end

    def info
      response = {}
      if present?
        ATTRIBUTES.each do |attribute|
          response.merge!({attribute => send(attribute)})
        end
      else
        response.merge!({:video_id => @video_id})
        response.merge!({:video_not_found => 'video_not_found'})
      end 
      response
    end

    def youtube? ; false ; end
    def vimeo? ; true ; end

    private

    def fetch_data
      @response = JSON.parse(
        ::Vimeo::Simple::Video.info(@video_id).response.body
      ).first
    end
  end
end

class String
  def youtube_duration_to_seconds
    hours =   match(/(\d+)H/)
    minutes = match(/(\d+)M/)
    seconds = match(/(\d+)S/)

    hours = hours     ? hours[1].to_i   : 0
    minutes = minutes ? minutes[1].to_i : 0
    seconds = seconds ? seconds[1].to_i : 0

    (hours * 3600) + (minutes * 60) + seconds
  end
end
