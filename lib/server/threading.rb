## Abstraction for thread implementation
module Threading
  def self.start &block
    Thread.new do
      block.call
    end
  end
end