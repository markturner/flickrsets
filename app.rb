require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'flickraw'
require 'json'

configure do  
  # Set API key
  FlickRaw.api_key="8e111f079960796424689d29fc4c5461"
  
  # set last update time
  @@last_updated = Time.now

  # get my user id
  @@user_id = flickr.people.findByUsername(:username => 'Mark Turner').id
  
  # get my photosets
  @@photosets = flickr.photosets.getList(:user_id => @@user_id).to_a
  
end

get '/' do
  
  array = []
  
  @@photosets[0..4].each do |set|
    
    # get the primary photo for thumbnail and photoset url
    primary = flickr.photos.getInfo(:photo_id => set.primary)
    
    array << {  :title => set.title, 
                :description => set.description,
                :count => set.photos,
                :thumbnail_url => FlickRaw.url_m(primary),
                :photoset_link_url => FlickRaw.url_photoset(primary) }.to_json
  end
  
  array.to_json
end