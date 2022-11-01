require_relative '../core/guards'
require_relative '../shared/route_resolver'

module Kirb
  class RouteGuard
    include Kirb::ValidationGuard
    include Kirb::InjectionGuard

    def initialize(route)
      @resolver = Kirb::RouteResolver.new route
    end

    def validate(ctx, data)
      valid, params, remain = @resolver.resolve ctx.route
      if valid
        data[:params] = params
        data[:remain] = remain
      end
      return valid
    end

    def inject(ctx, data)
      ctx.variable.remain_route = data[:remain]
      ctx.variable.accepted_params.merge! data[:params]
    end
  end
end

class String
  include Kirb::GuardFactory

  def guards
    [Kirb::RouteGuard.new(self)]
  end
end