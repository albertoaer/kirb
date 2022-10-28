require_relative 'routing_tree'

module Kirb
  class Context
    attr_reader :client, :request, :response, :router

    def initialize(client, request, response, router)
      @client = client
      @request = request
      @response = response
      @router = router
    end

    def nxt
      @router.nxt self
    end
  end
end