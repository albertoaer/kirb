module Kirb
  class Middleware
    attr_reader :payload

    def initialize(validation_guards, injection_guards, payload)
      @validation_guards = validation_guards
      @injection_guards = injection_guards
      @payload = payload
    end

    def validate ctx
      @validation_guards.map { |g| g.validate context }.all?
    end

    def inject ctx
      @injection_guards.each { |g| g.inject context }
    end
  end
end