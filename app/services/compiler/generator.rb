module Compiler
class Generator
  attr_reader :ast
  def initialize(ast, lang)
    @ast = ast
    @lang = lang
  end
  def generate(node)
    case node
    when FunctionNode

    else raise RuntimeError.new("Unexpected node type: #{node.class}")
    end
  end
end
end
