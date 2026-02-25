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
attr_accessor :parent
def initialize(location)
  @location = location
end
def to_s
  raise NotImplementedError, "No to_s method for #{class_name}"
end
def to_pseudocode
  raise NotImplementedError, "No to_pseudocode method for #{class_name}"
end

def to_english
  raise NotImplementedError, "No to_english method for #{class_name}"
end

protected

def indent
  tab_size = 4
  (" " * tab_size) * depth
end

def depth
  if parent.nil? || parent.is_a?(ProgramNode)
    0
  else
    1 + parent.depth
  end
end

private

def class_name
  self.class.name.split("::").last
end

def add_children(*children)
  children.each { it.parent = self }
end
end

class ProgramNode
  attr_accessor :nodes
  def initialize(nodes)
    @nodes = nodes
    nodes.each { |node| node.parent = self if node.respond_to?(:parent=) }
  end

  def to_s
    @nodes.each { it.to_s }.join("\n")
  end
end

  class ClassNode < ASTNode
    attr_accessor :body

    def initialize(body, location)
      super location
      @body = body
    end
    # missing string methods until java support is added
  end

class FunctionNode < ASTNode
attr_accessor :name, :arg_names, :body, :return_type, :modifiers
def initialize(name, arg_names, body, location, return_type = "untyped", modifiers = nil)
  super location
  @name = name
  @arg_names = arg_names
  @body = body
  @return_type = return_type
  @modifiers = modifiers
  add_children(*arg_names, *body)
end

def to_s
  <<~FUNCTION
    #{indent}#{class_name}(
    #{indent}NAME: #{@name}
    #{indent}MODIFIERS: #{@modifiers}
    #{indent}ARGS: #{@arg_names.map { it.to_s }.join(", ")}
    #{indent}BODY: #{@body.map { it.to_s }.join("\n")}
    #{indent}RETURN_TYPE: #{@return_type}
    #{indent})
  FUNCTION
end


def to_pseudocode
  args = @arg_names.map { it.to_pseudocode }.join(", ")
  body = @body.map { it.to_pseudocode }.join("\n")
  <<~FUNCTION
    #{indent}fn #{@name}(#{args}) -> #{@return_type}
        #{body}
    #{indent}end
  FUNCTION
end

def to_english
  args = @arg_names.map { it.to_english }.join(", ")
  "#{indent}DEFINE a function '#{@name}' with arguments (#{args}) that returns #{@return_type}"
end
end

  class ArgNode < ASTNode
    attr_accessor :type, :name

    def initialize(name, location, type = nil)
      super location
      @type = type
      @name = name
    end

    def to_s
      if @type.nil?
        "#{indent}#{class_name}(#{@name})"
      else
        "#{indent}#{class_name}(#{@type} #{@name})"
      end
    end

    def to_pseudocode
      if @type.nil?
        "#{indent}#{@name}"
      else
        "#{indent}#{@type} #{@name}"
      end
    end

    def to_english
      to_pseudocode
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
    add_children(left, right)
  end

  def to_s
    <<~BINARY_EXPR
      #{indent}#{class_name}(
      #{indent}LEFT: #{@left}
      #{indent}OPERATOR: #{@operator}
      #{indent}RIGHT: #{@right}
      #{indent})
    BINARY_EXPR
  end

  def to_pseudocode
    converted_operators =
      {
        ">" => "is greater than",
        "<" => "is less than",
        ">=" => "is greater than or equal to",
        "<=" => "is less than or equal to",
        "!=" => "is not equal to",
        "&&" => "and",
        "||" => "or"
      }

    if converted_operators.keys.include?(@operator)
      "#{@left.to_pseudocode} #{converted_operators[@operator]} #{@right.to_pseudocode}"
    else
      "#{@left.to_pseudocode} #{@operator} #{@right.to_pseudocode}"
    end
  end

  def to_english
    to_pseudocode
  end
end
  class UnaryExprNode < ExpressionNode
    attr_accessor :var, :operator, :is_prefix

    def initialize(var, operator, location, is_prefix:)
      super location
      @var = var
      @operator = operator
      @is_prefix = is_prefix
      add_children(var)
    end

    def to_s
      if @is_prefix
        "#{indent}#{class_name}(#{@operator}#{@var})"
      else
        "#{indent}#{class_name}(#{@var}#{@operator})"
      end
    end

    def to_pseudocode
      if @is_prefix
        "#{indent}#{@operator}#{@var.to_pseudocode}"
      else
        "#{indent}#{@var.to_pseudocode}#{@operator}"
      end
    end

    def to_english
      converted_operators =
        {
          "++" => "increment",
          "--" => "decrement"
        }
      if @is_prefix
        if converted_operators.keys.include?(@operator)
          "#{indent}pre-#{@operator}#{@var.to_english}"
        else
          "#{indent}#{@operator}#{@var.to_english}"
        end
      else
        if converted_operators.keys.include?(@operator)
          "#{indent}post-#{@operator}#{@var.to_english}"
        else
          "#{indent}#{@var.to_english}#{@operator}"
        end
      end
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

    def to_s
      "#{indent}#{class_name}"
    end

    def to_pseudocode
      "#{indent}continue"
    end

    def to_english
      to_pseudocode
    end
  end

  class BreakNode < StatementNode
    attr_accessor :value
    def initialize(value, location)
      super location
      @value = value
    end

    def to_s
      "#{indent}#{class_name}"
    end

    def to_pseudocode
      "#{indent}break"
    end

    def to_english
      to_pseudocode
    end
  end

  class RetNode < StatementNode
    attr_accessor :value
    def initialize(value, location)
      super location
      @value = value
      add_children(value)
    end

    def to_s
      "#{indent}#{class_name}(#{value})"
    end

    def to_pseudocode
      "#{indent}return #{value.to_pseudocode}"
    end

    def to_english
      to_pseudocode
    end
  end

  class ConditionalNode < StatementNode
    attr_accessor :condition, :body
    def initialize(condition, body, location)
      super location
      @condition = condition
      @body = body
      add_children(condition, *body)
    end
  end

  class IfNode < ConditionalNode
    attr_accessor :else_body
    def initialize(condition, body, location, else_body = nil)
      super(condition, body, location)
      @else_body = else_body
      if @else_body.is_a?(IfNode)
        add_children(else_body)
      else
        add_children(*else_body)
      end
    end

    def to_s
      <<~IF
        #{indent}#{class_name}(
        #{indent}CONDITION: #{@condition}
        #{indent}BODY: #{@body}
        #{indent}ELSE_BODY: #{@else_body}
        #{indent})
      IF
    end

    def to_pseudocode
      case @else_body
      when nil
        <<~IF_BLOCK
          #{indent}if #{@condition.to_pseudocode}
          #{indent}#{@body.map { it.to_pseudocode }.join("\n")}
          #{indent}end
        IF_BLOCK
      when IfNode
        <<~ELSE_IF
          #{indent}if #{@condition.to_pseudocode}
          #{indent}#{@body.map { it.to_pseudocode }.join("\n")}
          #{indent}else #{@else_body.to_pseudocode}}
        ELSE_IF
      else
        <<~ELSE
          #{indent}if #{@condition.to_pseudocode}
          #{indent}#{@body.map { it.to_pseudocode }.join("\n")}
          #{indent}#{@else_body.map { it.to_pseudocode }.join("\n")}
        ELSE
      end
    end

    def to_english
      to_pseudocode
    end
  end

  class WhileNode < ConditionalNode
    def initialize(condition, body, location)
      super(condition, body, location)
    end

    def to_s
      <<~WHILE
        #{indent}#{class_name}(
        #{indent}CONDITION: #{@condition}
        #{indent}BODY: #{@body.map { it.to_s }.join("\n")}
        #{indent})#{'   '}
      WHILE
    end
  end
  class ForNode < ConditionalNode
    attr_accessor :var_init, :increment
    def initialize(var_init, condition, increment, body, location)
      super(condition, body, location)
      @var_init = var_init
      @increment = increment
      add_children(var_init, increment)
    end

    def to_s
      <<~FOR
        #{indent}#{class_name}(
        #{indent}VAR_INIT: #{@var_init}
        #{indent}CONDITION: #{@condition}
        #{indent}INCREMENT: #{@increment}
        #{indent}BODY: #{@body.map { it.to_s }.join("\n")}
        #{indent})#{'   '}
      FOR
    end

    def to_pseudocode
      exclusives = %w[< > !=]
      var = @var_init.name
      start = @var_init.value
      if @condition.left.to_pseudocode == var
        final = @condition.right
      else
        final = @condition.left
      end
      range = exclusives.include?(@condition.operator) ? "exclusive" : "inclusive"
      <<~FOR
        #{indent}for #{var} from #{start.to_pseudocode} to #{final.to_pseudocode} #{range} do
        #{indent}#{@body.map { it.to_pseudocode }.join("\n")}
        #{indent}end
      FOR
    end

    def to_english
      to_pseudocode
    end
  end
  class ArrDeclNode < ExpressionNode
    attr_accessor :values
    def initialize(values, location)
      super location
      @values = values
      add_children(*values)
    end

    def to_s
      "#{indent}#{class_name}(#{values.map { it.to_s }})"
    end

    def to_pseudocode
      "#{indent}[#{@values.map { it.to_pseudocode }.join(", ")}]"
    end

    def to_english
      to_pseudocode
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
      add_children(value)
    end

    def to_s
      <<~DECLARATION
        #{indent}#{class_name}(
        #{indent}NAME: #{@name}
        #{indent}MODIFIERS: #{@modifiers}
        #{indent}DATA_TYPE: #{@data_type}
        #{indent}VALUE: #{@value}
        #{indent})
      DECLARATION
    end

    def to_pseudocode
      if %w[final const].any? { @modifiers.include?(it) }
        "#{indent}constant #{@name} = #{@value.to_pseudocode}"
      else
        "#{indent}#{@name} = #{@value.to_pseudocode}"
      end
    end

    def to_english
      if %w[final const].any? { @modifiers.include?(it) }
        "#{indent}DECLARE a constant #{@name} with value #{@value.to_english}"
      else
        "#{indent}DECLARE a variable #{@name} with value #{@value.to_english}"
      end
    end
  end

  class AssignmentNode < ExpressionNode
    attr_accessor :name, :operator, :value
    def initialize(name, operator, value, location)
      super location
      @name = name
      @operator = operator
      @value = value
      add_children(value)
    end

    def to_s
      <<~ASSIGNMENT
        #{indent}#{class_name}(
        #{indent}NAME: #{@name}
        #{indent}OPERATOR: #{@operator}
        #{indent}VALUE: #{@value}
        #{indent})
      ASSIGNMENT
    end

    def to_pseudocode
      "#{indent}#{@name} #{operator} #{@value.to_pseudocode}"
    end

    def to_english
      "#{indent}ASSIGN a variable #{@name} to value #{@value.to_english}"
    end
  end

class NumberNode < ExpressionNode
attr_accessor :value
def initialize(value, location)
  super location
  @value = value
end

def to_s
  "#{indent}#{class_name}(#{@value})"
end

def to_pseudocode
  "#{@value}"
end

def to_english
  to_pseudocode
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
    add_children(*arg_exprs)
  end

  def to_s
    <<~CALL
      #{indent}#{class_name}(
      #{indent}NAME: #{@name}
      #{indent}ARG_EXPRS: #{@arg_exprs.map { it.to_s }}
      #{indent})
    CALL
  end

  def to_pseudocode
    updated_name =
      case @name
      when "System.out.println", "console.log" then "println"
      when "System.out.print" then "print"
      when "System.out.printf" then "printf"
      else @name
      end
    "#{indent}#{updated_name}(#{@arg_exprs.map { it.to_pseudocode }.join(", ")})"
  end

  def to_english
    "#{indent}CALL a function #{@name} with arguments #{@arg_exprs.map { it.to_english }.join(", ")}"
  end
end

class VarRefNode < ExpressionNode
  attr_accessor :value
  def initialize(value, location)
    super location
    @value = value
  end

  def to_s
    "#{indent}#{class_name}(#{@value})"
  end

  def to_pseudocode
    "#{@value}"
  end

  def to_english
    to_pseudocode
  end
end

  class StringNode < ExpressionNode
    attr_accessor :value
    def initialize(value, location)
      super location
      @value = value
    end

    def to_s
      "#{indent}#{class_name}(#{@value})"
    end

    def to_pseudocode
      "#{@value}"
    end

    def to_english
      to_pseudocode
    end
  end

  class BoolNode < ExpressionNode
    attr_accessor :value
    def initialize(value, location)
      super location
      @value = value
    end

    def to_s
      "#{indent}#{class_name}(#{@value})"
    end

    def to_pseudocode
      "#{@value}"
    end

    def to_english
      to_pseudocode
    end
  end
end
