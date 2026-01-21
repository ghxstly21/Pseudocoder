module COMPILER
  require_relative "tokenizer"
  require_relative "parser"
  # require_relative "generator"
  class Compiler
  def compile(file)
    tokenizer = Tokenizer.new(File.read(file))
    tokens = tokenizer.tokenize
    parser = Parser.new(tokens,tokenizer.lang)
    ast = parser.parse
    # pseudocode = Generator.new(ast)
  end
  end
  end