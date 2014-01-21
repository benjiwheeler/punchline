task :rescore_punches => :environment do
  Meme.all.each do |meme|
    meme.generate_scores!
  end
end
