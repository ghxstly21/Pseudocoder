require_relative "ast"
require_relative "../../errors/compiler/generation_error"

module Compiler
class Generator
  attr_reader :ast, :instructions
  def initialize(ast)
    @ast = ast
    @instructions = []
  end

  # Generates pseudocode from the syntax tree nodes.
  def generate(node)
    return "" if node.nil?
    case node
    when ProgramNode
      @ast.nodes.map { generate(it) }.join("\n")
    when FunctionNode then generate_fn(node)
    when ExpressionNode then generate_expr(node)
    when StatementNode then generate_stmt(node)
    else raise GenerationError, "Currently unsupported node on type #{node.class} at #{node.location} Let support know!"
    end
  end

  private

  def generate_fn(node)
    return "" if node.nil?
    body = node.body.map { generate(it) }.join("\n    ")
    <<~FUNCTION
    fn #{node.name}(#{node.arg_names.join(", ")}) -> untyped
        #{body}
    end
    FUNCTION
  end

  def generate_expr(node)
    return "" if node.nil?
    case node
    when NumberNode, StringNode, VarRefNode then "#{node.value}"
    when CallNode
      print_calls = %w[System.out.println System.out.print console.log]
      node.name = "print" if print_calls.include?(node.name)
      "#{node.name}(#{node.arg_exprs.map { generate_expr(it) }.join(", ")})"
    when DeclarationNode
      if %w[final const].any? { node.modifiers.include?(it) }
        "constant #{node.name} = #{generate(node.value)}"
      else
        "#{node.name} = #{generate(node.value)}"
      end
    when AssignmentNode
      "#{node.name} = #{generate_expr(node.value)}"
    when BinaryExprNode then "#{generate(node.left)} #{node.operator} #{generate(node.right)}"
    when UnaryExprNode
      if node.is_prefix
        "#{node.operator}#{generate(node.var)}"
      else
        "#{generate(node.var)}#{node.operator}"
      end
    when ArrDeclNode
      "[#{node.values.join(", ")}]"
    else raise GenerationError, "Currently unsupported expression on type #{node.class} at #{node.location} Let support know!"
    end
  end

  def generate_stmt(node)
    return "" if node.nil?
    case node
    when ContinueNode then "continue"
    when BreakNode then "break"
    when RetNode then "return #{generate_expr(node.value)}"
    when ConditionalNode then generate_conditional(node)
    else raise GenerationError, "Currently unsupported statement on type #{node.class} at #{node.location}. Let support know!"
    end
  end

  def generate_conditional(node)
    return "" if node.nil?
    case node
    when IfNode then generate_if(node)
    when WhileNode then generate_while(node)
    when ForNode then generate_for(node)
    else raise GenerationError, "Currently unsupported conditional on type #{node.class} at #{node.location}. Let support know!"
    end
  end

  def generate_if(node)
    return "" if node.nil?
    condition = generate_expr(node.condition)
    body = node.body.map { generate(it) }.join("\n").gsub("\n", "\n    ")
    case (else_body = node.else_body)
    when nil
      node.else_body # : nil
      <<~IF_BLOCK
      if #{condition}
              #{body}
          end
      IF_BLOCK
    when IfNode
      (nested_if = else_body) or raise GenerationError, "Else body was unexpectedly nil." # :IfNode
      <<~ELSE_IF
      if #{condition}
              #{body}
          else #{generate_if(nested_if)}
      ELSE_IF
    else
      (else_exprs = else_body) or raise GenerationError, "Else body was unexpectedly nil." # : Array<Compiler::ExpressionNode>
      else_text = else_exprs.map { generate(it) }.join("\n").gsub("\n", "\n    ")
      <<~ELSE
      if #{condition}
              #{body}
          else
              #{else_text}
          end
      ELSE
    end
  end
  def generate_while(node)
    return "" if node.nil?
    condition = generate_expr(node.condition)
    body = node.body.map { generate_expr(it) }.join("\n").gsub("\n", "\n    ")
    <<~WHILE
    while #{condition}
            #{body}
        end
    WHILE
  end

  def generate_for(node)
    return "" if node.nil?
    if node.condition.is_a?(BinaryExprNode)
      exclusives = %w[< > !=]
      var = node.var_init.name
      start = node.var_init.value
      body = node.body.map { generate(it) }.join("\n").gsub("\n", "\n    ")
      if generate_expr(node.condition.left) == var
        final = node.condition.right
      else
        final = node.condition.left
      end
      range = exclusives.include?(node.condition.operator) ? "exclusive" : "inclusive"
      <<~FOR
      for #{var} from #{generate_expr(start)} to #{generate_expr(final)} #{range} do
              #{body}
          end
      FOR
    end
  end
end
end
