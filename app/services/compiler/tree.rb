module Compiler
  class Tree
    attr_accessor :root
    def initialize(root)
      if root.is_a?(Compiler::Node)
        @root = root
      else
        raise "Expected root to be a node, not a #{root.class}"
      end
    end
    def empty?
      @root.nil?
    end
    def clear
      @root = nil
    end

    def to_s
      node = root
      return "" unless node.is_a?(Compiler::Node)
      result = [ node.value ]
      root.children.each do |child|
        result << child.to_s
      end
      result.join("")
    end

    def pretty_print
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

  def size
    children.sum { |child| child.size } + 1
  end
  def add(type, value)
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
