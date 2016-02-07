namespace :bands do
    task :similar => :environment do
        puts "Finding similar artists...\n"
        
        bands = Band.all
        bands_with_events = []
        bands.each do |band|
            if band.events.count != 0
                bands_with_events.push(band)
            end
        end
        
        total = bands_with_events.count
        division = total / 20
        remainder = total % 20
        
        iterator = 0
        
        division.times do |n|
            20.times do |i|
                looped_band = bands_with_events[iterator]
            
                if looped_band.songkick_id != nil
                    similarCall = "http://developer.echonest.com/api/v4/artist/similar?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + looped_band.songkick_id.to_s + '&bucket=id:songkick&format=json'

                    echo_similar = Curl::Easy.new(similarCall) do |curl| end

                    echo_similar.perform

                    echo_similar_info = JSON.parse(echo_similar.body_str)
            
                    if echo_similar_info["response"]["status"]["code"] == 0
                        artists = echo_similar_info["response"]["artists"]
                        songkick_ids = []

                        artists.each do |artist|
                            if artist["foreign_ids"]
                                songkick_id = artist["foreign_ids"][0]["foreign_id"].tr!('songkick:artist:', '').to_i
                                if Band.find_by_songkick_id(songkick_id) == nil
                                    Band.create(songkick_id: songkick_id, name: artist["name"])
                                end
                                songkick_ids.push(songkick_id)
                            end
                        end

                        looped_band.update(similars: songkick_ids)
                    end
                end
                iterator = iterator + 1
            end
            sleep(60)
        end
        
        remainder.times do |i|
            looped_band = bands_with_events[iterator]
            
            if looped_band.songkick_id != nil
                similarCall = "http://developer.echonest.com/api/v4/artist/similar?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + looped_band.songkick_id.to_s + '&bucket=id:songkick&format=json'

                echo_similar = Curl::Easy.new(similarCall) do |curl| end

                echo_similar.perform

                echo_similar_info = JSON.parse(echo_similar.body_str)
            
                puts echo_similar_info["response"]
            
                if echo_similar_info["response"]["status"]["code"] == 0
                    artists = echo_similar_info["response"]["artists"]
                    songkick_ids = []

                    artists.each do |artist|
                        if artist["foreign_ids"]
                            songkick_id = artist["foreign_ids"][0]["foreign_id"].tr!('songkick:artist:', '').to_i
                            if Band.find_by_songkick_id(songkick_id) == nil
                                Band.create(songkick_id: songkick_id, name: artist["name"])
                            end
                            songkick_ids.push(songkick_id)
                        end
                    end

                    looped_band.update(similars: songkick_ids)
                end
            end
            iterator = iterator + 1
        end
        
        puts "Similar artists found.\n"
        
    end
end