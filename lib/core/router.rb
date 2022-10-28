require_relative 'routing_tree'

module Kirb
  class InvalidRoutingItem < StandardError
    def initialize(obj)
      super('Invalid routing item: ' + obj.pretty_inspect)
    end
  end

  class Router
    def initialize(tree)
      @tree = tree
    end

    def nxt(ctx)
      begin
        loop do
          node, @tree = @tree.nxt
          next unless node.validate ctx

          node.inject ctx
          payload = node.payload

          case payload
          when Proc
            return payload.call ctx
          when RoutingTree
            @tree = payload.iterate @tree
          else
            raise InvalidRoutingItem.new payload
          end
        end
      rescue NoNodesLeft
        return :none
      end
    end
  end
end