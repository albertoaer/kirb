require 'erb'

module Kirb
  class TemplateContext
    def initialize(wrapped, **params)
      @wrapped = wrapped
      @params = params
    end

    def method_missing(name, *args, **kwargs, &block)
      return @params[name] if @params.key? name
      # Should throw error if method does not exists?
      return nil unless @wrapped.class.method_defined? name
      @wrapped.send name, *args, **kwargs, &block
    end

    def use
      yield binding if block_given?
    end
  end

  class TemplateRenderer
    def initialize(data)
      @data = data
    end

    def render(context, **params)
      raise 'Not implemented'
    end
  end

  class ERBTemplateRenderer < TemplateRenderer
    def render(context, **params)
      TemplateContext.new(context, **params).use { |b| ERB.new(@data).result(b) }
    end
  end
end