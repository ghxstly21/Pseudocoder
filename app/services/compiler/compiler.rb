module Compiler
  require_relative "tokenizer"
  require_relative "parser"
  # require_relative "generator"


  # Compiles a file received as a path.
  # @raise Errno::ENOENT if the file does not exist
  # @raise UnsupportedLanguageError if the file extension is not .java, .js, or .py
  def self.compile_file(path)
      tokenizer = Tokenizer.new(path, from_file: true)
      tokens = tokenizer.tokenize
      parser = Parser.new(tokens, tokenizer.lang)
      ast = parser.parse
      end

  # Compiles a file received as a String
  # @raise LanguageRecognitionError if the code could not be identified as a supported language
  def self.compile_text(code)
    tokenizer = Tokenizer.new(code, from_file: false)
    tokens = tokenizer.tokenize
    parser = Parser.new(tokens, tokenizer.lang)
    ast = parser.parse
    # pseudocode = Generator.new(ast)
  end

  # Times compilation in seconds to 2 decimal points of precision
  def self.time
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start).round 2
  end
end
