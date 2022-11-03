module Kirb
  class ClosedResponse < StandardError
  end

  class HttpResponse
    attr_reader :headers, :message, :body
    attr_accessor :status

    def initialize(target)
      @target = target
      @headers = {}
      @status = 205
      @message = "OK"
      @body = ""
      @open = true
      @edit = lambda do |&block|
        raise EndedResponse.new unless @open
        block.call
      end
    end

    def [](header)
      return @headers[header]
    end

    def []=(header, value)
      @edit.call { @headers[header] = value }
    end

    def <<(bodypartial)
      @body << bodypartial
    end

    def end
      @open = false
    end

    def to_s
      <<~HTTP + body
      #{@target.version} #{@status} #{@message}\r
      #{@headers.map { |k,v| "#{k}: #{v}" }.join '\n\r'}\r
      \r
      HTTP
    end
  end
end