require 'bundler/setup'
Bundler.require

EventMachine.run do
  stream = ::Twitter::JSONStream.connect(
    :filters => "ruby,rails,collectiveidea",
    :auth    => "[username:password]",
    :ssl     => true
  )

  stream.each_item do |item|
    tweet = Yajl::Parser.parse(item)

    # {"text"=>"So.. I just found out Justin Bieber's in the...}
    puts tweet.inspect
  end
  
  # stream.on_error
  # stream.on_max_reconnects
end
