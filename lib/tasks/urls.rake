namespace :bands do
    task :urls => :environment do
        iterator = 1
        34.times do |n|
            20.times do |i|
                if Band.find(i + iterator).songkick_id != nil
                    urlsCall = "http://developer.echonest.com/api/v4/artist/urls?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + Band.find(i + iterator).songkick_id.to_s + '&format=json'

                    echo_urls = Curl::Easy.new(urlsCall) do |curl| end

                    echo_urls.perform

                    echo_urls_info = JSON.parse(echo_urls.body_str)
            
                    if echo_urls_info["response"]["status"]["code"] == 0
                        puts echo_urls_info["response"]["urls"][0]
                        if echo_urls_info["response"]["urls"] != nil
                            if echo_urls_info["response"]["urls"]["twitter_url"]
                                Band.find(i + iterator).update(twitter: echo_urls_info["response"]["urls"]["twitter_url"])
                            end
                            if echo_urls_info["response"]["urls"]["official_url"]
                                Band.find(i + iterator).update(website: echo_urls_info["response"]["urls"]["official_url"])
                            end
                        end
                    end
                end
            end
            iterator = iterator + 20
            sleep(60)
        end
        
    end
end