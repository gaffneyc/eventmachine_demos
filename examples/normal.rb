require 'socket'

server = TCPServer.new("0.0.0.0", 1845)

loop do
  client = server.accept

  while line = client.gets
    client.puts(line.chomp)
  end
end
