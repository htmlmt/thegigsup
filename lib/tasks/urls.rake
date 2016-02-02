namespace :bands do
    task :urls => :environment do
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
        
        iterator = 1
        division.times do |n|
            20.times do |i|
                if bands_with_events[i].songkick_id != nil
                    urlsCall = "http://developer.echonest.com/api/v4/artist/urls?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + bands_with_events[i].songkick_id.to_s + '&format=json'

                    echo_urls = Curl::Easy.new(urlsCall) do |curl| end

                    echo_urls.perform

                    echo_urls_info = JSON.parse(echo_urls.body_str)
            
                    if echo_urls_info["response"]["status"]["code"] == 0
                        if echo_urls_info["response"]["urls"] != nil
                            if echo_urls_info["response"]["urls"]["twitter_url"]
                                bands_with_events[i].update(twitter: echo_urls_info["response"]["urls"]["twitter_url"])
                            end
                            if echo_urls_info["response"]["urls"]["official_url"]
                                bands_with_events[i].update(website: echo_urls_info["response"]["urls"]["official_url"])
                            end
                        end
                    end
                end
            end
            iterator = iterator + 20
            sleep(60)
        end
        remainder.times do |i|
            if bands_with_events[i].songkick_id != nil
                urlsCall = "http://developer.echonest.com/api/v4/artist/urls?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + bands_with_events[i]).songkick_id.to_s + '&format=json'

                echo_urls = Curl::Easy.new(urlsCall) do |curl| end

                echo_urls.perform

                echo_urls_info = JSON.parse(echo_urls.body_str)
        
                if echo_urls_info["response"]["status"]["code"] == 0
                    puts echo_urls_info["response"]["urls"][0]
                    if echo_urls_info["response"]["urls"] != nil
                        if echo_urls_info["response"]["urls"]["twitter_url"]
                            bands_with_events[i].update(twitter: echo_urls_info["response"]["urls"]["twitter_url"])
                        end
                        if echo_urls_info["response"]["urls"]["official_url"]
                            bands_with_events[i].update(website: echo_urls_info["response"]["urls"]["official_url"])
                        end
                    end
                end
            end
        end
        
    end
end