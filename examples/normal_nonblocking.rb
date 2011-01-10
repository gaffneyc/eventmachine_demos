require 'socket'

server  = TCPServer.new(1845)
clients = []

loop do
  ready = IO.select([server] + clients)

  ready[0].each do |socket|
    if socket == server
      clients << socket.accept_nonblock
    else
      data = socket.recv_nonblock(256)
      
      if data.size > 0
        socket.sendmsg_nonblock(data)
      else
        clients.delete(socket)
      end
    end
  end
end