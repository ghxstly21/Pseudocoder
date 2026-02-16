require "bigdecimal"
module Compiler
  class Compiler
  end

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
    generator = Generator.new(ast)
    generator.generate(ast)
    end

  # Times compilation in seconds
  def self.time
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    adaptive_round(elapsed)
  end

  private

  # Rounds to the nearest decimal place that contains a nonzero digit.
  def self.adaptive_round(num)
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
