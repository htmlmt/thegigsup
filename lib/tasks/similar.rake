namespace :bands do
    task :similar => :environment do
        puts "Finding similar artists...\n"
        
        similarCall = "http://developer.echonest.com/api/v4/artist/similar?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + Band.find(10).songkick_id.to_s + '&bucket=id:songkick&format=json'

        echo_similar = Curl::Easy.new(similarCall) do |curl| end

        echo_similar.perform

        echo_similar_info = JSON.parse(echo_similar.body_str)

        artists = echo_similar_info["response"]["artists"]
        songkick_ids = []
        
        artists.each do |artist|
            songkick_id = artist["foreign_ids"][0]["foreign_id"].tr!('songkick:artist:', '').to_i
            Band.create(songkick_id: songkick_id, name: artist["name"])
            songkick_ids.push(songkick_id)
        end
        
        Band.find(10).update(similars: songkick_ids)
    end
end