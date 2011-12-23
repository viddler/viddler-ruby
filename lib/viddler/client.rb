module Viddler
  # Base class for accessing the Viddler API.
  #
  # For more information about the Viddler API, check out the documentation:
  # http://developers.viddler.com/documentation/api-v2/
  #
  # Examples
  # 
  #  # Initialize a client with just an API key
  #  viddler = Viddler::Client.new 'your api key'
  #  
  class Client
    DEFAULT_ENDPOINT = 'http://api.viddler.com/api/v2/'
    
    attr_accessor :api_key, :sessionid, :record_token
    
    # Sets the API key and sessionid if needed for the given arguments
    # 
    # api_key  - The String API Key from Viddler
    #
    # Examples
    #
    #  # Initialize a client with just an API key
    #  viddler = Viddler::Client.new 'your api key'
    #
    # Returns an instance of Viddler::Client
    def initialize(api_key)
      self.api_key = api_key
    end
    
    # Public: Simple method to determine if this is an authenticated client
    #
    # Examples
    #
    #   viddler = Viddler::Client.new 'abc123'
    #   viddler.authenticated?
    #   # => false
    #
    #   viddler = Viddler::Client.new 'abc123'
    #   viddler.authenticate! 'user', 'pass'
    #   viddler.authenticated?
    #   # => true
    #
    # Returns Boolean
    def authenticated?
      !sessionid.nil?
    end
    
    # Public: Authenticate the client using a username and password. Any
    #   subsequent calls will be made using the session.
    #
    # username - The String Viddler username
    # password - The String Viddler password
    #
    # Examples
    #
    #   viddler.authenticate! 'username', 'password'
    #
    # Returns a String sessionid
    def authenticate!(username, password, get_record_token=false)
      auth = get 'viddler.users.auth', :user => username, :password => password, :get_record_token => (get_record_token ? 1 : 0)
      self.record_token = auth['auth']['record_token'] if get_record_token
      self.sessionid = auth['auth']['sessionid']
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
      arguments[:api_key]   = api_key
      arguments[:sessionid] = sessionid if authenticated?
      JSON.parse RestClient.get(DEFAULT_ENDPOINT + method + '.json', :params => arguments)
    rescue RestClient::ExceptionWithResponse => e
      raise_api_exception e
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
      arguments[:api_key]   = api_key
      arguments[:sessionid] = sessionid if authenticated?
      JSON.parse RestClient.post(DEFAULT_ENDPOINT + method + '.json', arguments)
    rescue RestClient::ExceptionWithResponse => e
      raise_api_exception e
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
      # Call prepareUpload first, to get upload endpoint
      endpoint = get('viddler.videos.prepareUpload')["upload"]["endpoint"]
      
      # Need to use OrderedHash, because the API needs the file argument last
      ordered_arguments = ActiveSupport::OrderedHash.new
      
      arguments.each {|k,v| ordered_arguments[k] = v}
      
      ordered_arguments[:api_key]   = api_key
      ordered_arguments[:sessionid] = sessionid
      ordered_arguments[:file]      = file
      
      JSON.parse RestClient.post(endpoint, ordered_arguments)
    rescue RestClient::ExceptionWithResponse => e
      raise_api_exception e
    end
    
    private
    
    def raise_api_exception(exception)
      resp = JSON.parse(exception.response) 
      
      raise Viddler::ApiException.new(resp['error']['code'], resp['error']['description'], resp['error']['details']) if resp['error']
    end
  end
end