module Compiler
  require_relative "tokenizer"
  require_relative "parser"
  require_relative "generator"

  # Compiles an uploaded file or pasted code.
  # @raise Errno::ENOENT if the file does not exist
  # @raise Errno::EACCES if the compiler does not have permission to read the file
  # @raise UnsupportedLanguageError if the file extension is not .java, .js, or .py
  # @raise LanguageRecognitionError if the language could not be identified based on code alone
  # @raise TokenError if the code contains currently unsupported tokens
  # @raise SyntaxError if the code has incorrect syntax
  def self.compile(path_or_code, from_file: true)
    tokenizer = from_file ? Tokenizer.new(path_or_code) : Tokenizer.new(path_or_code, from_file: false)
    language = tokenizer.lang
    tokens = tokenizer.tokenize
    parser = Parser.new(tokens, language)
    ast = parser.parse
    generator = Generator.new(ast, language)
    generator.generate(ast)
    end

  # Times compilation in seconds to 2 decimal points of precision
  def self.time
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start).round 2
  end
end
