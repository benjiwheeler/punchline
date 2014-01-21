task :destroy_punches => :environment do
  Punch.destroy_all
  Tweet.destroy_all
  VoteDecision.destroy_all
end
