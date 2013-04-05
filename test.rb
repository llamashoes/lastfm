require 'lastfm_lib'

#LastFM Key
key = "<key here>"
username = "<username here>" #can be ar ARGV later on

lfm = LastFm.new
lfm.ListAllTracks(key, username)
