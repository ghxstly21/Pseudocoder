require "bigdecimal"
require_relative "ast"
require_relative "tokenizer"
require_relative "parser"
require_relative "generator"

module Compiler
  class Compiler
  attr_reader :language, :ast_text, :english

  # Compiles an uploaded file or pasted code into pseudocode.
  # @raise Errno::ENOENT if the file does not exist
  # @raise Errno::EACCES if the compiler does not have permission to read the file
  # @raise UnsupportedLanguageError if the file extension is not .java, .js, or .py
  # @raise LanguageRecognitionError if the language could not be identified based on code alone
  # @raise TokenError if the code contains currently unsupported tokens
  # @raise SyntaxError if the code has incorrect syntax
  # @raise NotImplementedError if the generator failed on a node because of an unimplemented function
  # @raise GenerationError if generation for a piece of code has not been implemented
  def compile(path_or_code, from_file: true)
    tokenizer = Tokenizer.new(path_or_code, from_file: from_file)
    @language = tokenizer.lang
    tokens = tokenizer.tokenize
    parser = Parser.new(tokens, @language)
    ast = parser.parse
    generator = Generator.new(ast)
    generator.generate(ast)
    @english = generator.english
    @ast_text = generator.ast_text
    end

  # Times compilation in seconds.
  def time
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    adaptive_round(elapsed)
  end

  private

  # Rounds to the nearest decimal place that contains a nonzero digit.
  def adaptive_round(num)
    n_digits = nil # the first nonzero index
    num_as_string = BigDecimal(num).to_s("F") # bigdecimal is used to avoid conversion to scientific notation
    fractional_part = num_as_string.split(".")[1]
    fractional_part.each_char.with_index(1) do |char, i|
      digit = char.to_i
      if digit == 0
        next
      elsif digit >= 5
        n_digits = i - 1
        break
      else
        n_digits = i
        break
      end
    end
    n_digits.nil? || n_digits < 2 ? num.round(2) : num.round(n_digits)
  end
  end
end
