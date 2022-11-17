require_relative 'routing_tree'
require_relative 'template_renderer'

module Kirb
  class VariableContextData
    attr_accessor :remain_route
    attr_accessor :accepted_params

    def initialize(request)
      @remain_route = request.route
      @accepted_params = {}
      @query = request.query
      @query_hash = nil
    end

    def query
      @query_hash = @query.split('&').map do |v|
        key, val = v.split('=')
        [key.to_sym, val]
      end.to_h if @query_hash.nil?
      return @query_hash
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

    def status(code)
      @response.status = code
    end

    def content_type(ctype)
      @response['Content-Type'] = ctype
    end

    def route
      @request.verb + '#' + @variable.remain_route
    end

    def params
      @variable.accepted_params
    end

    def query
      @variable.query
    end

    def nxt
      @router.nxt self
    end

    def file(route)
      @response << File.read(route)
    end

    def render(route, **params)
      template = File.read(route)
      @response << ERBTemplateRenderer.new(template).render(self, **params)
    end

    def string(data)
      @response << data
    end
  end
end