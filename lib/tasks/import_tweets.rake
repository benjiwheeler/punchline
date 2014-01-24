task :import_tweets => :environment do
  Meme.all.shuffle.each do |meme|
    meme.pull_tweets
  end
end
