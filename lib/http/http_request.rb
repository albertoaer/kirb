require_relative '../shared/route_resolver'

module Kirb
  class HttpParseError < StandardError
    def initialize msg
      super msg
    end
  end

  class HttpRequest
    attr_reader :verb, :route, :query, :version, :headers, :body

    ##
    # @param verb [String]
    # @param route [String]
    # @param query [String]
    # @param version [String]
    # @param headers [Hash]
    # @param body [String]
    def initialize(verb, route, query, version, headers, body)
      @verb = verb
      @route = route
      @query = query
      @version = version
      @headers = headers
      @body = body
    end

    def self.parse(raw)
      bodysplit = raw.index("\r\n\r\n")
      headerraw = raw[0..bodysplit-1]
      bodyraw = raw[bodysplit+4..-1]

      lines = headerraw.split("\r\n")
      raise HttpParseError.new 'No headers' if lines.empty?
      verb, route, version = lines.shift.match(/(\w+)\s+(.*?)\s+(.*)/).captures

      parts = RouteValidator.parts route
      raise HttpParseError.new 'Invalid route' if parts.nil?
      
      verb.upcase!
      raise HttpParseError.new 'Invalid method' unless METHODS.include? verb
      
      raise HttpParseError.new 'Invalid http request format' unless verb and route and version
      headers = lines.map { |ln| ln.match(/^([\w-]+): (.*)$/).captures }
      raise HttpParseError.new 'Invalid http headers format' unless headers.all?
      
      HttpRequest.new verb, parts[0], parts[1], version, headers.to_h, bodyraw
    end
  end
end