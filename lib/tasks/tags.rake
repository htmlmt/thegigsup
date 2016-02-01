namespace :bands do
    task :similar => :environment do
        puts "Finding tags...\n"
        
        20.times do |i|
            looped_band = Band.find(i + 1)
            
            termsCall = "http://developer.echonest.com/api/v4/artist/terms?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + looped_band.songkick_id.to_s + '&format=json'

            echo_terms = Curl::Easy.new(termsCall) do |curl| end

            echo_terms.perform

            echo_terms_info = JSON.parse(echo_terms.body_str)

            terms_response = echo_terms_info["response"]["terms"]

            terms = []

            terms_response.each do |term|
                terms.push(term["name"])
            end

            looped_band.update(tags: terms)
        end
        
        puts "Tags found.\n"
    end
end