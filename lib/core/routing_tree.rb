module Kirb
  class NoNodesLeft < StandardError
  end

  class LockedTree < StandardError
  end

  class RuntimeRoutingTree
    def initialize(nodes, parent)
      @nodes = nodes
      @parent = parent
      @idx = 0
    end

    def nxt(&condition)
      if @idx < @nodes.size
        n = @nodes[@idx]
        @idx += 1
        return n.iterate(self).nxt if n.is_a? RoutingTree
        return n, self
      end
      raise NoNodesLeft.new if @parent.nil?
      return @parent.nxt
    end
  end

  class RoutingTree
    def initialize(nodes=[])
      @nodes = nodes
      @locked = false
    end

    def add(node)
      raise LockedTree.new if @locked
      @nodes << node
    end

    alias_method :<<, :add

    def iterate(from=nil)
      RuntimeRoutingTree.new(@nodes, from)
    end

    # Prepare the controller for execution
    def prepare
      @locked = true
    end
  end
end