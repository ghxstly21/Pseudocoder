module Compiler
  class LocationRange
    attr_accessor :start_loc, :end_loc
    def initialize(start_loc, end_loc)
      @start_loc = start_loc
      @end_loc = end_loc
    end
  end

class ASTNode
attr_reader :location
def initialize(location)
  @location = location
end
end

class ProgramNode
  attr_accessor :nodes
  def initialize(nodes)
    @nodes = nodes
  end
end

class FunctionNode < ASTNode
attr_accessor :name, :arg_names, :body
def initialize(name, arg_names, body, location)
  super location
  @name = name
  @arg_names = arg_names
  @body = body
end
end

class BinaryExprNode < ExpressionNode
  attr_accessor :left, :operator, :right

  def initialize(left, operator, right, location)
    super location
    @left = left
    @operator = operator
    @right = right
  end
end

  class StatementNode < ASTNode
  end

  class ContinueNode < StatementNode
    attr_accessor :value
    def initialize(value, location)
      super location
      @value = value
    end
  end

  class BreakNode < StatementNode
    attr_accessor :value
    def initialize(value, location)
      super location
      @value = value
    end
  end

  class ConditionalNode < StatementNode
    attr_accessor :condition, :body
    def initialize(condition, body, location)
      super location
      @condition = condition
      @body = body
    end
  end

  class IfNode < ConditionalNode
    attr_accessor :else_body
    def initialize(condition, body, location, else_body = nil)
      super(condition, body, location)
      @else_body = else_body
    end
  end

  class WhileNode < ConditionalNode

    def initialize(condition, body, location)
      super(condition, body, location)
    end
  end

class ExpressionNode < ASTNode
end

class NumberNode < ExpressionNode
attr_accessor :value
def initialize(value, location)
  super location
  @value = value
end
end

class IntegerNode < NumberNode
end

class FloatNode < NumberNode
end

class ExponentialNode < NumberNode
end

class CallNode < ExpressionNode
  attr_accessor :name, :arg_exprs
  def initialize(name, arg_exprs, location)
    super location
    @name = name
    @arg_exprs = arg_exprs
end
end

class VarRefNode < ExpressionNode
  attr_accessor :value
  def initialize(value, location)
    super location
    @value = value
  end
end
end
