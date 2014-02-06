task :send_push => :environment do
  class ParseRESTAPI
    include HTTParty
    base_uri 'https://api.parse.com/1'
  end

  options = {
    headers: {
      'X-Parse-Application-Id' => 'dBLDlVSjVJaI3SWMcy9NwpuswJ00Mj7298ERUWRp',
      'X-Parse-REST-API-Key' => 'b5EZmQDaTejXvqCkO5QCcJx1keD3ceiUzAlxuC3A',
      'Content-Type' => 'application/json'
    },
    body: {
      "where" => {"deviceType" => "ios"}, 
      "data" => {"alert" => "Hello Zeitgeist! This was sent from rails!"}
    }
  }

  ap ParseRESTAPI.post('/push', options)
end
