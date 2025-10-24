module COMPILER
  require_relative "tokenizer"
  require_relative "parser"
  # require_relative "generator"
  class Compiler
  def compile(file)
    tokenizer = Tokenizer.new(File.read(file))
    tokens = tokenizer.tokenize
    ast = Parser.new(tokens,tokenizer.lang)
    pseudocode = Generator.new(ast)
  end
  end
  end