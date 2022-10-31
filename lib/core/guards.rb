module Kirb
  ##
  # Guard for context validation
  module ValidationGuard
    ##
    # Determine whether a context satisfies the guard
    # @param ctx [Context] the context
    # @return [Boolean]
    def validate ctx
      raise 'Not implemented'
    end
  end

  ##
  # Guard for data injection
  module InjectionGuard
    ##
    # Injects data into the context
    # @param ctx [Context] the context
    def inject ctx
      raise 'Not implemented'
    end
  end

  ##
  # Guard that require dependencies
  module DependencyGuard
    ##
    # Notify required Dependencies
    # @return [Array]
    def require
      raise 'Not implemented'
    end

    ##
    # Use the provided dependencies
    # @param dependencies [Array]
    def prepare deps
      raise 'Not implemented'
    end
  end

  ##
  # Factory for guard creation
  module GuardFactory
    ##
    # Produces one or more guards
    # @return [Array<Guard>]
    def guards
      raise 'Not implemented'
    end
  end
end