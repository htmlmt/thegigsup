namespace :bands do
    task :similar => :environment do
        puts "Finding tags...\n"
        
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
                    termsCall = "http://developer.echonest.com/api/v4/artist/terms?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + looped_band.songkick_id.to_s + '&format=json'

                    echo_terms = Curl::Easy.new(termsCall) do |curl| end

                    echo_terms.perform

                    echo_terms_info = JSON.parse(echo_terms.body_str)
            
                    if echo_terms_info["response"]["status"]["code"] == 0
                        terms_response = echo_terms_info["response"]["terms"]

                        terms = []
            
                        terms_response.each do |term|
                            terms.push(term["name"])
                        end

                        looped_band.update(tags: terms)
                    end
                end
                iterator = iterator + 1
            end
            sleep(60)
        end
        
        remainder.times do |i|
            looped_band = bands_with_events[iterator]
            
            if looped_band.songkick_id != nil
                termsCall = "http://developer.echonest.com/api/v4/artist/terms?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + looped_band.songkick_id.to_s + '&format=json'

                echo_terms = Curl::Easy.new(termsCall) do |curl| end

                echo_terms.perform

                echo_terms_info = JSON.parse(echo_terms.body_str)
        
                if echo_terms_info["response"]["status"]["code"] == 0
                    terms_response = echo_terms_info["response"]["terms"]

                    terms = []
        
                    terms_response.each do |term|
                        terms.push(term["name"])
                    end

                    looped_band.update(tags: terms)
                end
            end
            iterator = iterator + 1
        end
        
        puts "Tags found.\n"
        
    end
end