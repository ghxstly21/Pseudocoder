module Compiler
  require_relative "tokenizer"
  require_relative "parser"
  # require_relative "generator"

  def self.compile(file)
    if File.exist?(file)
      tokenizer = Tokenizer.new(File.read(file))
      tokens = tokenizer.tokenize(from_file: true)
    else
      tokenizer = Tokenizer.new(file)
      tokens = tokenizer.tokenize(from_file: false)
    end
    parser = Parser.new(tokens, tokenizer.lang)
    ast = parser.parse
    # pseudocode = Generator.new(ast)
  end

  def self.time
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start).round 2
  end
end
