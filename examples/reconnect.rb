require 'bundler/setup'
require 'eventmachine'

module Server
  def post_init
    EM.add_timer(1) do
      puts "Server: Closing"
      close_connection
    end
  end
end

class Client < EventMachine::Connection
  # Reconnect requires host / port but it isn't possible to get them from the
  # instance so we have to pass them in.
  def initialize(host, port)
    @host = host
    @port = port
  end

  # Client#unbind will be called each time the client is disconnected as well as
  # each time the client fails to connect. This means it will keep trying until
  # it gets a connection.
  def unbind
    EM.add_timer(1) do
      puts "Client: Reconnecting to #{@host}:#{@port}"

      # Reconnect can be called with a different host / port and it will reuse
      # the same connection instance.
      reconnect(@host, @port)
    end
  end
end

trap("INT") do
  EventMachine.stop_event_loop
end

EventMachine.run do
  HOST = 'localhost'
  PORT = 1846

  # Any parameters given after the connection handler will be passed into
  # the initialize method.
  EventMachine.connect(HOST, PORT, Client, HOST, PORT)

  EventMachine.start_server('0.0.0.0', PORT, Server)
end

