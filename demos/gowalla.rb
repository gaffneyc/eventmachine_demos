require 'bundler/setup'
Bundler.require

EventMachine.run do
  query = {
    :lat    => '37.704276',
    :lng    => '-85.871227',
    :radius => 50
  }

  head = { :accept => 'application/json' }
  http = EventMachine::HttpRequest.new("http://api.gowalla.com/spots").get(:query => query, :head => head)

  http.callback do
    data = Yajl::Parser.parse(http.response)

    data['spots'].each do |spot|
      puts "#{spot['name']} @ #{spot['lat']}:#{spot['lng']}"
    end

    EM.stop
  end
end
