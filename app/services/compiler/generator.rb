require_relative "ast"

module Compiler
class Generator
  attr_reader :ast
  def initialize(ast)
    @ast = ast
  end

  # Generates pseudocode from the syntax tree nodes.
  def generate(node)
    return "" if node.nil?
    case node
    when ProgramNode
      generate(ast.nodes.first)
    when FunctionNode
      <<~FUNCTION
        function #{node.name}(#{node.arg_names.join(", ")}) do
            #{node.body.each { generate(it) }}
        end
        FUNCTION
    when ExpressionNode
      case node
      when NumberNode || VarRefNode then "#{node.value}"
      when CallNode then "#{node.name}(#{node.arg_exprs.join(", ")})"
      when DeclarationNode
        if %w[final const].any? { node.modifiers.include?(it) }
          "constant #{node.name} = #{generate(node.value)}"
        else
          "#{node.name} = #{generate(node.value)}"
        end
      when BinaryExprNode then "#{generate(node.left)} #{operator} #{generate(node.right)}"
      when UnaryExprNode
        if node.is_prefix
          "#{node.operator}#{generate(node.var)}"
        else
          "#{generate(node.var)}#{node.operator}"
        end
      else raise "Currently unsupported expression on type #{node.class} at #{node.location} Let support know!"
      end
    when StatementNode
      case node
      when ContinueNode then "continue"
      when BreakNode then "break"
      when RetNode then "return #{generate(node.value)}"
      when ConditionalNode then "not implemented yet"
      else raise "Currently unsupported expression on type #{node.class} at #{node.location}. Let support know!"
      end
    else raise RuntimeError.new("Unexpected node type: #{node.class}")
    end
  end
end
end
