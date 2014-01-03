task :import_tweets => :environment do
  Meme.all.each do |meme|
    meme.pull_tweets
  end
end
