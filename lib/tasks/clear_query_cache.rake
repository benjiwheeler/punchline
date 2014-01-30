task :clear_query_cache => :environment do
  Punch.connection.clear_query_cache
  User.connection.clear_query_cache
  Vote.connection.clear_query_cache
  VoteDecision.connection.clear_query_cache
  Authorization.connection.clear_query_cache
  Tweet.connection.clear_query_cache
end
