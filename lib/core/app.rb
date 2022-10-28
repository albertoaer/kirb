require_relative 'controller'
require_relative 'context'
require_relative 'router'
require_relative '../server/server'

module Kirb
  class App
    def initialize
      @main_controller = Controller.new
      yield @main_controller if block_given?
    end

    def listen(port, ip='127.0.0.1')
      @main_controller.prepare
      server = Server.new ip, port do |client, req|
        #Asume the handler will be executed in a separated thread
        router = @main_controller.create_router
        ctx = Context.new client, req, router
        ctx.nxt
      end
      server.start
    end

    def ctr
      return @main_controller
    end
  end
end