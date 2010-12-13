module Viddler
  # Base class for accessing the Viddler API.
  #
  # For more information about the Viddler API, check out the documentation:
  # http://api.viddler.com/api/v2/
  #
  # Examples
  # 
  #  # Initialize a client with just an API key
  #  viddler = Viddler::Client.new 'your api key'
  #  
  #  # Create an authenticated client. Every call made with this will use your
  #  # session
  #  viddler = Viddler::Client.new 'your api key', 'your username', 'your password'
  #
  class Client
    DEFAULT_ENDPOINT = 'http://api.viddler.com/api/v2'
    
    attr_accessor :api_key
    
    def initialize(api_key, username=nil, password=nil)
      self.api_key = api_key
    end

    # Public: Make a GET call to the Viddler API.
    #
    # method    - The String API method you'd like to call.
    # arguments - The Hash of arguments to the API method (default: {}).
    #
    # Examples
    #
    #   viddler.get 'viddler.videos.getDetails', :video_id => 'abc123'
    #
    # Returns a Hash containing the API response
    # Raises ApiException if an error is returned from the API
    def get(method, arguments={})
      
    end
  end
end
