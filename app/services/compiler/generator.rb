require_relative "ast"
require_relative "../../errors/compiler/generation_error"

module Compiler
class Generator

  attr_reader :ast_text, :english

  def initialize(ast)
    @ast = ast

    @ast_text = @ast.nodes.map { it.to_s }.join("\n")
    @english = @ast.nodes.map { it.to_english }.join("\n")

    # if show_instructions
    #   @step_list = []
    #   @emit_step = lambda { |s| @step_list << s }
    # else
    #   @emit_step = lambda { |_| }
    # end

    # @show_instructions = show_instructions
  end



  # Generates pseudocode from the syntax tree nodes.
  def generate(node)
    if node.is_a?(ProgramNode)
      @ast.nodes.map { it.to_pseudocode }.join("\n")
    else
      raise GenerationError, "Expected ast to be wrapped in a program node, got #{}"
    end

    # return "" if node.nil?
    # case node
    # when ProgramNode then @ast.nodes.map { generate(it) }.join("\n")
    # when FunctionNode then generate_fn(node)
    # when ExpressionNode then generate_expr(node)
    # when StatementNode then generate_stmt(node)
    # when ArgNode
    #   if node.type.nil?
    #     "#{node.name}"
    #   else
    #     "#{node.type} #{node.name}"
    #   end
    # else raise GenerationError, "Currently unsupported node on type #{node.class} at #{node.location} Let support know!"
    # end
  end

  private

  # def emit_block
  #   original_lambda = @emit_step
  #   if @show_instructions
  #     block_steps = []
  #     @emit_step = lambda { |s| block_steps << s }
  #     result = yield.to_s
  #     @step_list << block_steps.join(" ")
  #   else
  #     result = yield.to_s
  #   end
  #   result
  # ensure
  #   @emit_step = original_lambda
  #   result
  # end
  #
  # def generate_fn(node)
  #   return "" if node.nil?
  #   args = node.arg_names.map { generate(it) }.join(", ")
  #   @emit_step.call("Define a function #{node.name} with arguments (#{args}) that returns #{node.return_type}: ")
  #   body = emit_block { node.body.map { generate(it) }.join("\n    ") }
  #   <<~FUNCTION
  #   fn #{node.name}(#{args}) -> #{node.return_type}
  #       #{body}
  #   end
  #   FUNCTION
  # end
  #
  # def generate_expr(node)
  #   return "" if node.nil?
  #   case node
  #   when NumberNode, StringNode, BoolNode, VarRefNode then "#{node.value}"
  #   when CallNode
  #     node.name =
  #       case node.name
  #       when "System.out.println", "console.log" then "println"
  #       when "System.out.print" then "print"
  #       when "System.out.printf" then "printf"
  #       else node.name
  #       end
  #
  #     emit_block { @emit_step.call("Call a function #{node.name} with arguments (#{node.arg_exprs.map { generate_expr(it) }.join(", ")})") }
  #     "#{node.name}(#{node.arg_exprs.map { generate_expr(it) }.join(", ")})"
  #   when DeclarationNode
  #     if %w[final const].any? { node.modifiers.include?(it) }
  #       emit_block { @emit_step.call("Declare a constant #{node.name} and set it equal to #{generate(node.value)}") }
  #       "constant #{node.name} = #{generate(node.value)}"
  #     else
  #       emit_block { @emit_step.call("Declare a variable #{node.name} and set it equal to #{generate(node.value)}") }
  #       "#{node.name} = #{generate(node.value)}"
  #     end
  #   when AssignmentNode
  #     emit_block { @emit_step.call("Assign #{node.name} to #{generate_expr(node.value)}") }
  #     "#{node.name} = #{generate_expr(node.value)}"
  #   when BinaryExprNode
  #     node.operator =
  #       case node.operator
  #       when ">" then "is greater than"
  #       when "<" then "is less than"
  #       when ">=" then "is greater than or equal to"
  #       when "<=" then "is less than or equal to"
  #       when "==" then "is equal to"
  #       when "!=" then "is not equal to"
  #       when "&&" then "and"
  #       when "||" then "or"
  #       else node.operator
  #       end
  #     "#{generate(node.left)} #{node.operator} #{generate(node.right)}"
  #   when UnaryExprNode
  #     if node.is_prefix
  #       emit_block { @emit_step.call("#{node.operator}#{generate(node.var)}") }
  #       "#{node.operator}#{generate(node.var)}"
  #     else
  #       emit_block { @emit_step.call("#{generate(node.var)}#{node.operator}") }
  #       "#{generate(node.var)}#{node.operator}"
  #     end
  #   when ArrDeclNode
  #     @emit_step.call("[#{node.values.join(", ")}]")
  #     "[#{node.values.join(", ")}]"
  #   else raise GenerationError, "Currently unsupported expression on type #{node.class} at #{node.location} Let support know!"
  #   end
  # end
  #
  # def generate_stmt(node)
  #   return "" if node.nil?
  #   case node
  #   when ContinueNode
  #     @emit_step.call("continue the loop")
  #     "continue"
  #   when BreakNode
  #     @emit_step.call("break out of the loop")
  #     "break"
  #   when RetNode
  #     emit_block { @emit_step.call("return #{generate_expr(node.value)}") }
  #     "return #{generate_expr(node.value)}"
  #   when ConditionalNode then generate_conditional(node)
  #   else raise GenerationError, "Currently unsupported statement on type #{node.class} at #{node.location}. Let support know!"
  #   end
  # end
  #
  # def generate_conditional(node)
  #   return "" if node.nil?
  #   case node
  #   when IfNode then generate_if(node)
  #   when WhileNode then generate_while(node)
  #   when ForNode then generate_for(node)
  #   else raise GenerationError, "Currently unsupported conditional on type #{node.class} at #{node.location}. Let support know!"
  #   end
  # end
  #
  # def generate_if(node)
  #   return "" if node.nil?
  #   condition = generate_expr(node.condition)
  #   body = node.body.map { generate(it) }.join("\n").gsub("\n", "\n    ")
  #   case (else_body = node.else_body)
  #   when nil
  #     emit_block do
  #       @emit_step.call("if #{generate_expr(node.condition)} then #{node.body.map { generate it }.join("\n").gsub("\n", "\n    ")}")
  #     end
  #     node.else_body # : nil
  #     <<~IF_BLOCK
  #     if #{condition}
  #             #{body}
  #         end
  #     IF_BLOCK
  #   when IfNode
  #     (nested_if = else_body) or raise GenerationError, "Else body was unexpectedly nil." # :IfNode
  #     emit_block do
  #       @emit_step.call("
  #       if #{generate_expr(node.condition)} then #{node.body.map { generate it }.join("\n").gsub("\n", "\n    ")} else if #{generate_if(else_body)}")
  #     end
  #     <<~ELSE_IF
  #     if #{condition}
  #             #{body}
  #         else #{generate_if(nested_if)}
  #     ELSE_IF
  #   else
  #     (else_exprs = else_body) or raise GenerationError, "Else body was unexpectedly nil." # : Array<Compiler::ExpressionNode>
  #     else_text = else_exprs.map { generate(it) }.join("\n").gsub("\n", "\n    ")
  #     <<~ELSE
  #     if #{condition}
  #             #{body}
  #         else
  #             #{else_text}
  #         end
  #     ELSE
  #   end
  # end
  # def generate_while(node)
  #   return "" if node.nil?
  #   condition = generate_expr(node.condition)
  #   body = node.body.map { generate_expr(it) }.join("\n").gsub("\n", "\n    ")
  #   <<~WHILE
  #   while #{condition}
  #           #{body}
  #       end
  #   WHILE
  # end
  #
  # def generate_for(node)
  #   return "" if node.nil?
  #   if node.condition.is_a?(BinaryExprNode)
  #     exclusives = %w[< > !=]
  #     var = node.var_init.name
  #     start = node.var_init.value
  #     body = node.body.map { generate(it) }.join("\n").gsub("\n", "\n    ")
  #     if generate_expr(node.condition.left) == var
  #       final = node.condition.right
  #     else
  #       final = node.condition.left
  #     end
  #     range = exclusives.include?(node.condition.operator) ? "exclusive" : "inclusive"
  #     <<~FOR
  #     for #{var} from #{generate_expr(start)} to #{generate_expr(final)} #{range} do
  #             #{body}
  #         end
  #     FOR
  #   end
  # end
  end
end
