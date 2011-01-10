require 'socket'

server = TCPServer.new("0.0.0.0", 1845)

loop do
  client = server.accept

  Thread.new do
    while line = client.gets
      client.write(line)
    end
  end
end
