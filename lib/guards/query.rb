require_relative '../core/guards'

module Kirb  
  class QueryGuard
    include Kirb::ValidationGuard
    include Kirb::InjectionGuard
    include Kirb::PredefinableGuard

    def initialize(name)
      @name = name
      @default = nil
    end

    def validate(ctx, data)
      !!ctx.query[@name] or !@default.nil?
    end
    
    def inject(ctx, data)
      if !ctx.query[@name] and !@default.nil?
        ctx.query[@name] = @default
      end
    end
  end
end

class Symbol
  include Kirb::GuardFactory

  def guards
    [Kirb::QueryGuard.new(self)]
  end
end