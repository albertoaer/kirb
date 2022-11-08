module Kirb
  ##
  # Guard for context validation
  module ValidationGuard
    ##
    # Determine whether a context satisfies the guard
    # @param ctx [Context] the context
    # @param data [Hash] the transaction data
    # @return [Boolean]
    def validate ctx, data
      raise 'Not implemented'
    end
  end

  ##
  # Guard for data injection
  module InjectionGuard
    ##
    # Injects data into the context
    # @param ctx [Context] the context
    # @param data [Hash] the transaction data
    def inject ctx, data
      raise 'Not implemented'
    end
  end

  ##
  # Guard that allows a default value or configuration
  module PredefinableGuard
    def set_default value
      @default = value
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