module Kirb
  module ValidationGuard
    def validate(context)
      raise 'Not implemented'
    end
  end

  module InjectionGuard
    def inject(context)
      raise 'Not implemented'
    end
  end
end