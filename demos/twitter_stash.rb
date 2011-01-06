require 'bundler/setup'
Bundler.require

# This is bad, use optparse which is part of the standard lib for any real
# option parsing.
if ARGV.size != 2
  puts "Usage: demos/twitter_stash.rb \"username:password\" \"search,terms,separated,by,commas\""
  exit
end

trap("INT") do
  EventMachine.stop_event_loop
end

EventMachine.run do
  # Establish a connection to Mongo and fetch the needed database and collection.
  # Any inserts / reads will be done on the collection.
  mongo  = EM::Mongo::Connection.new.db("eventmachine_demos")
  tweets = mongo.collection("tweets")

  # Configure the stream and connect it to twitter. This can take several useful
  # options like host and path so it can be used for more than just twitter. See
  # the JSONStream code for a full list.
  stream = ::Twitter::JSONStream.connect(
    :filters => ARGV[1].split(','),
    :auth    => ARGV[0],
    :ssl     => true
  )

  # Set up the callback for messages being received. Each message from the
  # stream is received as a string that needs to be parsed. Yajl is my JSON
  # parser of choice.
  stream.each_item do |item|
    tweet = Yajl::Parser.parse(item)

    text = tweet['text']
    user = tweet['user']['screen_name']

    tweets.insert({
      :text => text,
      :user => user
    })

    puts "#{user} - #{text}"
  end

  # Callback for errors, usually authentication errors.
  stream.on_error do |message|
    puts "ERROR: #{message}"
  end

  # Fail whale.
  stream.on_max_reconnects do |timeout, retries|
    puts "Twitter is having trouble, too many retry attempts"
    EventMachine.stop_event_loop
  end
end
