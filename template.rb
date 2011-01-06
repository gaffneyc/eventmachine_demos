require 'rubygems'
require 'eventmachine'

class Server < EventMachine::Connection
  # def post_init
  # def receive_data(data)
  # def unbind
end

class Client < EventMachine::Connection
  # def post_init
  # def connection_completed
  # def receive_data(data)
  # def unbind
end

# Ctrl-C to cleanly stop the server
trap("INT") do
  EventMachine.stop_event_loop
end

EventMachine.run do
  # Start a server
  EventMachine.start_server('0.0.0.0', 1845, Server)

  # Connect a client
  EventMachine.connect('localhost', 1845, Client)
end
