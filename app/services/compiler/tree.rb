module COMPILER
class Tree
  attr_accessor :list, :root
  def initialize(type, root)
    @root = Node.new(type, root)
    @list = [ @root ]
  end
  def add_node(parent, type, value)
    begin
    @list.append(parent.add_child(type, value))
    rescue RuntimeError
      return false
      end
    true
    end
  def to_s
    "Tree as an array:
     #{list}"
  end
end

class Node
  attr_reader :children, :value, :type
  def initialize(type, value)
    if type.is_a?(Symbol)
    @type = type
    else
      raise "Expected data type of the node's type to be Symbol, but got #{type.class}."
    end
    @value = value
    @children = []
  end

  def add_child(type, value)
    added_node = Node.new(type, value)
    @children.append(added_node)
    added_node
  end
  def inspect
    "NODE(Type: #{type}, Value: #{value})
     \t#{children}"
  end
end
end
