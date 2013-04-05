require 'lastfm_lib'

#LastFM Key
key = "05b13c72c513d9a32b8e574283f75146"
username = "llamashoes" #can be ar ARGV later on

lfm = LastFm.new
lfm.ListAllTracks(key, username)
