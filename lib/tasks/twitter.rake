namespace :bands do
    task :twitter => :environment do
        20.times do |i|
            twitterCall = "http://developer.echonest.com/api/v4/artist/twitter?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + Band.find(i + 21).songkick_id.to_s + '&format=json'

            echo_twitter = Curl::Easy.new(twitterCall) do |curl| end

            echo_twitter.perform

            echo_twitter_info = JSON.parse(echo_twitter.body_str)
            
            if echo_twitter_info["response"]["status"]["code"] == 0
                if echo_twitter_info["response"]["artist"]["twitter"]
                    twitter_handle = echo_twitter_info["response"]["artist"]["twitter"]
                else
                    twitter_handle = ''
                end
            end

            Band.find(i + 1).update(twitter: twitter_handle)
        end
    end
end