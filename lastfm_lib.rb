#library for lastfm stuff

require 'net/http'
require 'uri'
require 'xmlsimple'

class LastFm
	$all_data = []
	
	# This method will list all tracks
	def ListAllTracks(key, username, limit=100)
		current_page = 1 #used to parse all pages
		
		info = main_action(current_page, key, limit)		

		#Get Total Pages
		page_info = get_pages(info)
		#puts page_info	

		total_pages = page_info['total_pages']
		current_page = page_info['current_page']
		per_page = page_info['per_page']

		while current_page <= total_pages
			puts "#{current_page}:#{total_pages}"
			info = main_action(current_page, key, limit)
			list_track(info)
			current_page = current_page + 1
		end
		file = File.open("all_tracks.txt", 'w')
		$all_data.each {|d| file.puts "#{d}\n"}
		file.close
		return info
	end

	def main_action(current_page, key, limit)
		response = http_go(current_page, key, limit)
                info = parse_xml_simple(response)
		return info
	end
	
	def list_track(info)
		 info['tracks'][0]['track'].each {|y| $all_data << "#{y['name']} - #{y['artist'][0]['name']} - #{y['playcount']}"}
	end

	def parse_xml_simple(data)
		xml_data = data.body
		info = XmlSimple.xml_in(xml_data)
		return info
	end

	def http_go(page, key, limit)
		baseurl = "http://ws.audioscrobbler.com/2.0/?method=library.gettracks&api_key=#{key}"
                user = "llamashoes"
		
		#Create Request
                request = URI.parse(baseurl + "&user=#{user}&limit=#{limit}&page=#{page}")

		#Get Response
                response = Net::HTTP.get_response(request)
		
	end

	def get_pages(info)
		pages_info = Hash.new
		
		pages_info["total_pages"] = info['tracks'][0]['totalPages'].to_i
		pages_info["current_page"] = info['tracks'][0]['page'].to_i
		pages_info["per_page"] = info['tracks'][0]['perPage'].to_i
		return pages_info
	end


end
