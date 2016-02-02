namespace :bands do
    task :video => :environment do
        iterator = 21
        34.times do |n|
            20.times do |i|
                videoCall = "http://developer.echonest.com/api/v4/artist/video?api_key=" + ENV["ECHO_API_KEY"] + '&id=songkick:artist:' + Band.find(i + iterator).songkick_id.to_s + '&format=json&results=1&start=0'

                echo_video = Curl::Easy.new(videoCall) do |curl| end

                echo_video.perform

                echo_video_info = JSON.parse(echo_video.body_str)
            
                puts echo_video_info
            
                if echo_video_info["response"]["status"]["code"] == 0
                    puts echo_video_info["response"]["video"]
                end
            end
            iterator = iterator + 20
            sleep(60)
        end
        
    end
end