require_relative '../core/guards'

module Kirb
  class ManyGuards
    include Kirb::GuardFactory
    
    def initialize(guard_aray)
      @guards = guard_aray
    end

    def guards
      @guards
    end
  end

  def self.def(guard, val)
    guards = guard.class.include?(GuardFactory) ? guard.guards + [guard] : [guard]
    guards.each { |g| g.set_default(val) if g.class.include? Kirb::PredefinableGuard }
    ManyGuards.new guards
  end
end