require 'socket'
require_relative 'threading'
require_relative '../http/http_request'
require_relative '../http/http_response'

module Kirb
  class Server
    def initialize(ip, port, block_size=2048, &handler)
      @ip = ip
      @port = port
      @block_size = block_size
      @handler = handler
    end

    def start
      server = TCPServer.new @ip, @port
      begin
        loop do
          client = server.accept
          Threading.start do
            client_handler client
          end
        end
      rescue Interrupt
        puts 'Server closed'
      end
    end

    def client_handler(client)
      begin
        input = client.readpartial @block_size
        request = HttpRequest.parse input
        response = HttpResponse.new request
        @handler.call client, request, response
      rescue EOFError
      end
    end

    def respond(client, response)
      #TODO: Do not close if keep alive
      client.write response
      client.close
    end
  end
end