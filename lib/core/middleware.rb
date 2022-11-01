module Kirb
  class Middleware
    attr_reader :payload

    ##
    # @param validation_guards [Array]
    # @param injection_guards [Array]
    # @param payload
    def initialize(validation_guards, injection_guards, payload)
      @validation_guards = validation_guards
      @injection_guards = injection_guards
      @eq_guard_assoc = validation_guards.map do |vg|
        injection_guards.index { |ig| ig.object_id == vg.object_id }
      end
      @payload = payload
    end

    def new_transaction
      Array.new(@eq_guard_assoc.size) { |i| @eq_guard_assoc[i] ? {} : nil }
    end

    def validate ctx, transac
      @validation_guards.map.with_index { |g, i| g.validate ctx, transac[i] }.all?
    end

    def inject ctx, transac
      @injection_guards.each.with_index { |g, i| g.inject ctx, transac[@eq_guard_assoc[i]] }
    end
  end
end