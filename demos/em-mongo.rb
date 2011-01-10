require 'bundler/setup'
Bundler.require

EventMachine.run do
  mongo  = EM::Mongo::Connection.new.db("demos")
  tweets = mongo.collection("tweets")

  tweets.insert({ :user => 'gaffneyc', :text => 'Hello from Ruby::AZ'})
  tweets.find(:user => 'gaffneyc') do |results|
    # [{"_id"=>BSON::ObjectId('4d2a0037f50f833b19000001'), "user"=>"gaffneyc", "text"=>"Hello from Ruby::AZ"}]
    puts results.inspect
  end
  
  # tweets.remove(id)
  # tweets.update(conditions, updates)
end