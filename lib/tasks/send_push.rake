task :send_push => :environment do
  class ParseRESTAPI
    include HTTParty
    base_uri 'https://api.parse.com/1'
  end

  headers = {
      'X-Parse-Application-Id' => 'dBLDlVSjVJaI3SWMcy9NwpuswJ00Mj7298ERUWRp',
      'X-Parse-REST-API-Key' => 'b5EZmQDaTejXvqCkO5QCcJx1keD3ceiUzAlxuC3A',
      'Content-Type' => 'application/json'
  }

  opts = { :count => 1, :result_type => 'mixed', include_rts: 1 }
  push_content = ""
  tweet_id = ""
  Meme.new.twitter_client.user_timeline("Telepathy_CU", opts).each.with_index(1) do |twitter_info, i|
    push_content = twitter_info.text
    tweet_id = twitter_info.id.to_s
  end




  body = {
    "where" => {"deviceType" => "ios"}, 
    data: {alert: "New tweet: #{push_content}",
      tweet_id: tweet_id
}
    }.to_json
    #  "where" => {"deviceType" => "ios"}, 
#      "data" => {"alert" => "Hello Zeitgeist! This was sent from rails!"}

  ap ParseRESTAPI.post('/push', body: body, headers: headers)
end

