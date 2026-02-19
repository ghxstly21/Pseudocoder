module Compiler
  class Ast
  end

  class LocationRange
    attr_accessor :start_loc, :end_loc
    def initialize(start_loc, end_loc)
      if start_loc.is_a?(LocationRange)
        @start_loc = start_loc.start_loc
      else
        @start_loc = start_loc
      end
      if end_loc.is_a?(LocationRange)
        @end_loc = end_loc.end_loc
      else
        @end_loc = end_loc
      end
    end

    def to_s
      if @start_loc.line == @end_loc.line
        "Line #{@start_loc.line}, Position #{@start_loc.column}-#{@end_loc.column}\n"
      else
        "Line #{@start_loc.line}, position #{@start_loc.column} - line #{@end_loc.line}, position #{end_loc.column}\n"
      end
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

  class ClassNode < ASTNode
    attr_accessor :body

    def initialize(body, location)
      super location
      @body = body
    end
  end

class FunctionNode < ASTNode
attr_accessor :name, :arg_names, :body, :return_type
def initialize(name, arg_names, body, location, return_type = nil)
  super location
  @name = name
  @arg_names = arg_names
  @body = body
  @return_type = return_type
end
end

  class ArgNode < ASTNode
    attr_accessor :type, :name

    def initialize(name, location, type = nil)
      super location
      @type = type
      @name = name
    end
  end
  class ExpressionNode < ASTNode
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
  class UnaryExprNode < ExpressionNode
    attr_accessor :var, :operator, :is_prefix

    def initialize(var, operator, location, is_prefix:)
      super location
      @var = var
      @operator = operator
      @is_prefix = is_prefix
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
  class RetNode < StatementNode
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

  class ForNode < ConditionalNode
    attr_accessor :var_init, :increment
    def initialize(var_init, condition, increment, body, location)
      super(condition, body, location)
      @var_init = var_init
      @increment = increment
    end
  end
  class ArrDeclNode < ExpressionNode
    attr_accessor :values
    def initialize(values, location)
      super location
      @values = values
    end
  end

  class DeclarationNode < ExpressionNode
    attr_accessor :modifiers, :data_type, :name, :value
    def initialize(modifiers, name, value, location, data_type = nil)
      super location
      @modifiers = modifiers
      @data_type = data_type
      @name = name
      @value = value
    end
  end

  class AssignmentNode < ExpressionNode
    attr_accessor :name, :value
    def initialize(name, value, location)
      super location
      @name = name
      @value = value
      @location = location
    end
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

  class StringNode < ExpressionNode
    attr_accessor :value
    def initialize(value, location)
      super location
      @value = value
    end
  end
end
