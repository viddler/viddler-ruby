viddler-ruby
============

viddler-ruby is the officially supported gem for [Viddler's V2 API](http://developers.viddler.com/documentation/api-v2/).

Installation
------------

    $ gem install viddler-ruby
    
### Rails 2

Add the following to your `config/environment.rb`:

    config.gem 'viddler-ruby'
    
Make sure to run `rake gems:install` afterwards.

### Rails 3 and Bundler

Add the following to your Gemfile:

    gem 'viddler-ruby'
    
Make sure to run `bundle install` afterwards

### Other

To use in a regular Ruby project:

    require 'rubygems'
    require 'viddler-ruby'

Usage
-----

viddler-ruby provides a simple interface to [Viddler](http://viddler.com)'s API.  To use, just instantiate an instance of Viddler::Client and call the `#get` and `#post` methods. For example, to get the details of a video:

    viddler = Viddler::Client.new('your api key')
    video = viddler.get 'viddler.videos.getDetails', :video_id => 'abc123'
    
    puts video['title'] # => "My video"
    puts video['id']    # => "abc123"
    
For an authenticated client, just call `authenticate!` on the client:

    viddler = Viddler::Client.new('your api key')
    viddler.authenticate! 'username', 'password'
    
Then, any calls made on `viddler` will be done using the correct session id.

Uploading
---------

To upload a file, use the upload method:

    viddler.upload(File.open('./myvideo.mov'), {
      :title       => 'My video',
      :description => 'This video is awesome!',
      :tags        => 'awesome'
    })