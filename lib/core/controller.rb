require_relative 'middleware'
require_relative 'routing_tree'
require_relative 'context'
require_relative 'guards'
require_relative 'router'

module Kirb
  class Controller
    attr_reader :tree

    def initialize(tree=RoutingTree.new)
      @tree = tree
      @controllers = [] #Keep track of the controllers
    end

    # Include new middleware block with its guards
    def use(*guards, &block)
      validation, injection = filter_guards(guards)
      @tree << Middleware.new(validation, injection, block)
    end

    # Include new middleware controller with its guards
    def use_controller(controller, *guards)
      validation, injection = filter_guards(guards)
      @controllers << controller
      @tree << Middleware.new(validation, injection, controller.tree)
    end

    # Create a new router from the tree
    def create_router
      Router.new @tree.iterate
    end

    # Prepare the controller for execution
    def prepare
      @controllers.each { |ctr| ctr.prepare }
      @tree.prepare
    end

    def filter_guards(guards)
      raise ArgumentError.new 'Expecting array of guards' unless guards.is_a? Array
      validation = []
      injection = []
      guards.each do |g|
        if g.class.include? GuardFactory
          v, i = filter_guards(g.guards)
          validation = validation + v
          injection = injection + i
        end
        validation << g if g.class.include? ValidationGuard
        injection << g if g.class.include? InjectionGuard
      end
      return validation, injection
    end
  end
end