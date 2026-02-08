require_relative "ast"

module Compiler
class Generator
  attr_reader :ast
  def initialize(ast)
    @ast = ast
  end
  def generate(node)
    return "" if node.nil?
    case node
    when ProgramNode
      generate(ast.nodes.first)
    when FunctionNode
      <<~FUNCTION
        function #{node.name}(#{node.arg_names.join(", ")}) do
            #{generate(node.body)}
        end
        FUNCTION
    when ExpressionNode
      case node
      when NumberNode || VarRefNode then "#{node.value}"
      when CallNode then "#{node.name}(#{node.arg_exprs.join(", ")})"
      else raise "Currently unsupported expression on type #{node.class} at location #{node.location}.\nAdd a case!"
      end
    else raise RuntimeError.new("Unexpected node type: #{node.class}")
    end
  end
end
end
