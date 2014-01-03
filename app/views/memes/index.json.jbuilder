json.array!(@memes) do |meme|
  json.extract! meme, :id, :tag
  json.url meme_url(meme, format: :json)
end
