json.array!(@hashtags) do |hashtag|
  json.extract! hashtag, :id, :content
  json.url hashtag_url(hashtag, format: :json)
end
