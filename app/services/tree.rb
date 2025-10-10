class Tree
  attr_accessor :node_count, :branch
  def initialize
    @node_count = node_count
  end
  def create_branch(parent)
    branch = [Node.new(parent)]
    node_count += 1
  end
  def add_node(parent)

  end
  def to_s
    "something"
  end
end

class Node
  def initialize(value)

  end
end