require_relative 'routing_tree'

module Kirb
  class VariableContextData
    attr_accessor :remain_route
    attr_accessor :accepted_params

    def initialize(request)
      @remain_route = request.route
      @accepted_params = {}
    end
  end

  class Context
    attr_reader :client, :request, :response, :router, :variable

    ##
    # @param client
    # @param request [Request]
    # @param response [Response]
    # @param router [Router]
    def initialize(client, request, response, router)
      @client = client
      @request = request
      @response = response
      @router = router
      @variable = VariableContextData.new request
    end

    def status(n=nil)
      @response.status = n unless n.nil?
      @response.status
    end

    def route
      @request.verb + '#' + @variable.remain_route
    end

    def params
      @variable.accepted_params
    end

    def nxt
      @router.nxt self
    end
  end
end