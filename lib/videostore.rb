require 'faraday'
require 'google/api_client'
require 'vimeo'


module VideoStore
  class Video
    class << self
    end
  end

  class Youtube < Video
    DEVELOPER_KEY = "AIzaSyAvAE2p-TTo1b4oSRCg4qzR5sE8o8c_8J8"
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
    end # end of class methods
    establish_connection

    attr_accessor :uri




  end # end of Youtube class
end
  
  #puts VideoStore::Youtube.connection.inspect
  user_info = Vimeo::Simple::User.info("matthooks")
  puts user_info


# client = Google::APIClient.new
# puts client.inspect
#plus = client.d


 # # Initialize the client & Google+ API
 #    require 'google/api_client'
 #    client = Google::APIClient.new
 #    plus = client.discovered_api('plus')

 #    # Initialize OAuth 2.0 client    
 #    client.authorization.client_id = '<CLIENT_ID_FROM_API_CONSOLE>'
 #    client.authorization.client_secret = '<CLIENT_SECRET>'
 #    client.authorization.redirect_uri = '<YOUR_REDIRECT_URI>'
    
 #    client.authorization.scope = 'https://www.googleapis.com/auth/plus.me'

 #    # Request authorization
 #    redirect_uri = client.authorization.authorization_uri

 #    # Wait for authorization code then exchange for token
 #    client.authorization.code = '....'
 #    client.authorization.fetch_access_token!

 #    # Make an API call
 #    result = client.execute(
 #      :api_method => plus.activities.list,
 #      :parameters => {'collection' => 'public', 'userId' => 'me'}
 #    )
 #    puts result.data

#  conn = Faraday.new(:url => 'http://youtube.com') do |faraday|
#   faraday.request  :url_encoded             # form-encode POST params
#   faraday.response :logger                  # log requests to STDOUT
#   faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
# end

# response = conn.get '/watch?v=7cIES6Nggs'  # returns 301 to blank page
# puts response.body 
