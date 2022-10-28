require_relative 'routing_tree'

module Kirb
  class Context
    attr_reader :client, :request, :router

    def initialize(client, request, router)
      @client = client
      @request = request
      @router = router
    end

    def nxt
      @router.nxt self
    end
  end
end