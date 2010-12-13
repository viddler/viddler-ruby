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
    
    # Sets the API key and sessionid if needed for the given arguments
    # 
    # api_key  - The String API Key from Viddler
    # username - The String Viddler username. Only needed for an
    #            unauthenticated call. (optional)
    # password - The String Viddler password. Only needed for an
    #            unauthenticated call. (optional)
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
    # Returns an instance of Viddler::Client
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
    # Returns a Hash containing the API response.
    # Raises ApiException if an error is returned from the API.
    def get(method, arguments={})
      
    end
    
    # Public: Make a POST call to the Viddler API.
    #
    # method    - The String API method you'd like to call.
    # arguments - The Hash of arguments to the API method (default: {}).
    #
    # Examples
    #
    #   viddler.post 'viddler.videos.setDetails', :video_id => 'abc123',
    #                                             :title    => 'new title'
    #
    # Returns a Hash containing the API response.
    # Raises ApiException if an error is returned from the API.
    def post(method, arguments={})
      
    end
    
    # Public: Upload a video to the Viddler API.
    #
    # file      - The File you are uploading
    # arguments - The Hash of arguments for the video
    #             :title       - The String title of the video
    #             :tags        - The String of tags for the video
    #             :description - The String description of the video
    #             :make_public - The Boolean to make the video public on
    #                            upload. Please note that if set to false, it
    #                            will not make your video private.
    #
    # Examples
    # 
    #   viddler.upload File.open('myvideo.avi'), :title       => "My Video",
    #                                            :tags        => "viddler, ruby",
    #                                            :description => "This is cool"
    #
    # Returns a Hash containing the API response.
    # Raises ApiException if an error is returned from the API
    def upload(file, arguments)
      
    end
  end
end
