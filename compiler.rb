class Tokenizer
  PYTHON_TOKENS = [
    :def, "\bdef\b",
  :if, "\bif\b"
  ]
  JAVA_TOKENS = []
  RUBY_TOKENS = []
  def initialize(code)
    @code = code
  end
  def tokenize(code)
  end

  tokens = Tokenizer.new(File.read("test.txt"))
  end