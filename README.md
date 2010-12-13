viddler-ruby
============

viddler-ruby provides a simple interface to [Viddler](http://viddler.com)'s API.  To use, just instantiate an instance of Viddler::Client and call the `#get` and `#post` methods. For example, to get the details of a video:

    viddler = Viddler::Client.new('your api key')
    video = viddler.get 'viddler.videos.getDetails', :video_id => 'abc123'
    
    puts video['title'] # => "My video"
    puts video['id']    # => "abc123"
    
For an authenticated client, just pass a username and password:

    viddler = Viddler::Client.new('your api key', 'username', 'password')
    
Then, any calls made on `viddler` will be done using the correct session id.

Uploading
---------

To upload a file, use the upload method:

    viddler.upload(File.open('./myvideo.mov'), {
      :title       => 'My video',
      :description => 'This video is awesome!',
      :tags        => 'awesome'
    })