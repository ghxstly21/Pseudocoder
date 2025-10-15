module COMPILER
class Tokenizer
  def initialize(code)
    @code = code
    @lang = nil
  end
  attr_reader :code, :lang
  PYTHON_TOKENS = [
    [ :and, /\band\b/ ],
    [ :break, /\bbreak\b/ ],
    [ :case, /\bcase\b/ ],
    [ :class, /\bclass\b/ ],
    [ :continue, /\bcontinue\b/ ],
    [ :def, /\bdef\b/ ],
    [ :elif, /\belif\b/ ],
    [ :else, /\belse\b/ ],
    [ :catch, /\bexcept\b/ ],
    [ :finally, /\bfinally\b/ ],
    [ :for, /\bfor\b/ ],
    [ :if, /\bif\b/ ],
    [ :in, /\bin\b/ ],
    [ :is, /\bis\b/ ],
    [ :lambda, /\blambda\b/ ],
    [ :not, /\bnot\b/ ],
    [ :or, /\bor\b/ ],
    [ :throw, /\braise\b/ ],
    [ :return, /\breturn\b/ ],
    [ :try, /\btry\b/ ],
    [ :while, /\bwhile\b/ ],
    [ :yield, /\byield/ ],
    [ :colon, /:/ ],
    [ :true, /\bTrue\b/ ],
    [ :false, /\bFalse\b/ ],
    [ :identifier, /\b[A-Za-z_][A-Za-z0-9_]*\b/ ],
    [ :number, /\b[0-9]+\b/ ],
    [ :open_paren, /\(/ ],
    [ :close_paren, /\)/ ],
    [ :add, /\+/ ],
    [ :sub, /-/ ],
    [ :multiply, /\*/ ],
    [ :divide, /\// ],
    [ :comparison, /(>=|<=|==|>|<)/ ],
    [ :assignment, /=/ ]

  ]
  JAVA_TOKENS = [
    [ :assert, /\bassert\b/ ],
    [ :bool, /\bboolean\b/ ],
    [ :break, /\bbreak\b/ ],
    [ :case, /\bcase\b/ ],
    [ :catch, /\bcatch\b/ ],
    [ :class, /\bclass\b/ ],
    [ :continue, /\bcontinue\b/ ],
    [ :default, /\bdefault\b/ ],
    [ :do, /\bdo\b/ ],
    [ :else, /\belse\b/ ],
    [ :enum, /\benum\b/ ],
    [ :finally, /\bfinally\b/ ],
    [ :for, /\bfor\b/ ],
    [ :if, /\bif\b/ ],
    [ :instanceof, /\binstanceof\b/ ],
    [ :interface, /\binterface\b/ ],
    [ :new, /\bnew\b/ ],
    [ :requires, /\brequires\b/ ],
    [ :return, /\breturn\b/ ],
    [ :switch, /\bswitch\b/ ],
    [ :throw, /\bthrow\b/ ],
    [ :throws, /\bthrows\b/ ],
    [ :try, /\btry\b/ ],
    [ :void, /\bvoid\b/ ],
    [ :while, /\bwhile\b/ ],
    [ :true, /\btrue\b/ ],
    [ :false, /\bfalse\b/ ],
    [ :string, /"(\\.|[^"\\])*"/ ],
    [ :number, /\b[0-9]+\b/ ],
    [ :identifier, /\b[A-Za-z_][A-Za-z0-9_]*\b/ ],
    [ :open_paren, /\(/ ],
    [ :close_paren, /\)/ ],
    [ :open_brace, /\{/ ],
    [ :close_brace, /}/ ],
    [ :open_bracket, /\[/ ],
    [ :close_bracket, /\]/ ],
    [ :semicolon, /;/ ],
    [ :dot, /\./ ],
    [ :comma, /,/ ],
    [ :add, /\+/ ],
    [ :sub, /-/ ],
    [ :multiply, /\*/ ],
    [ :divide, /\// ],
    [ :comparison, /(>=|<=|==|>|<)/ ],
    [ :assignment, /=/ ]
  ]

JS_TOKENS = [
  [ :abstract, /\babstract\b/ ],
  [ :break, /\bbreak\b/ ],
  [ :case, /\bcase\b/ ],
  [ :catch, /\bcatch\b/ ],
  [ :class, /\bclass\b/ ],
  [ :continue, /\bcontinue\b/ ],
  [ :default, /\bdefault\b/ ],
  [ :do, /\bdo\b/ ],
  [ :else, /\belse\b/ ],
  [ :enum, /\benum\b/ ],
  [ :false, /\bfalse\b/ ],
  [ :finally, /\bfinally\b/ ],
  [ :for, /\bfor\b/ ],
  [ :function, /\bfunction\b/ ],
  [ :if, /\bif\b/ ],
  [ :in, /\bin\b/ ],
  [ :instanceof, /\binstanceof\b/ ],
  [ :new, /\bnew\b/ ],
  [ :null, /\bnull\b/ ],
  [ :return, /\breturn\b/ ],
  [ :super, /\bsuper\b/ ],
  [ :switch, /\bswitch\b/ ],
  [ :this, /\bthis\b/ ],
  [ :throw, /\bthrow\b/ ],
  [ :throws, /\bthrows\b/ ],
  [ :true, /\btrue\b/ ],
  [ :try, /\btry\b/ ],
  [ :typeof, /\btypeof\b/ ],
  [ :while, /\bwhile\b/ ],
  [ :with, /\bwith\b/ ],
  [ :yield, /\byield\b/ ],
  [ :string, /"(\\.|[^"\\])*"/ ],
  [ :open_brace, /\{/ ],
  [ :close_brace, /}/ ],
  [ :open_bracket, /\[/ ],
  [ :close_bracket, /\]/ ],
  [ :semicolon, /;/ ],
  [ :dot, /\./ ],
  [ :comma, /,/ ],
  [ :const, /\bconst\b/ ],
  [ :identifier, /\b[A-Za-z_][A-Za-z0-9_]*\b/ ],
  [ :number, /\b[0-9]+\b/ ],
  [ :open_paren, /\(/ ],
  [ :close_paren, /\)/ ],
  [ :add, /\+/ ],
  [ :sub, /-/ ],
  [ :multiply, /\*/ ],
  [ :divide, /\// ],
  [ :comparison, /(>=|<=|===|==|>|<)/ ],
  [ :assignment, /=/ ]
]

  def identify_lang
    # establish general tokens
    general_tokens = []
    py_types = PYTHON_TOKENS.map { |pair| pair[1] }
    java_types = JAVA_TOKENS.map { |pair| pair[1] }
    js_types = JS_TOKENS.map { |pair| pair[1] }
    py_types.each_with_index { |py_token, i|
      if java_types.include?(py_token) && js_types.include?(py_token)
        general_tokens.append(PYTHON_TOKENS[i])
      end
    }
    java_types.each_with_index { |java_token, i|
      if !general_tokens.include?(JAVA_TOKENS[i]) && py_types.include?(java_token) && js_types.include?(java_token)
        general_tokens.append(JAVA_TOKENS[i])
      end
    }
    js_types.each_with_index { |js_token, i|
      if !general_tokens.include?(JS_TOKENS[i]) && py_types.include?(js_token) && java_types.include?(js_token)
        general_tokens.append(JS_TOKENS[i])
      end
    }
    puts general_tokens
    # find the most likely language
    python_count = 0
    java_count = 0
    js_count = 0
    PYTHON_TOKENS.each do |py_token|
      if !general_tokens.include?(py_token) && @code.match?(py_token[1])
        python_count += 1
      end
    end
    JAVA_TOKENS.each do |java_token|
      if !general_tokens.include?(java_token) && @code.match?(java_token[1])
        java_count += 1
      end
    end
    JS_TOKENS.each do |js_token|
      if !general_tokens.include?(js_token) && @code.match?(js_token[1])
        js_count += 1
      end
    end
    max = [ python_count, java_count, js_count ].max
    if max == python_count
      @lang = "python"
    elsif max == java_count
      @lang = "java"
    elsif max == js_count
      @lang = "javascript"
    elsif js_count==java_count
      @lang = "javascript"
    else
      raise RuntimeError("Language could not be recognized as Java, Python, or JavaScript")
    end
  end

  def tokenize
    begin
      identify_lang
    rescue
      puts("Could not identify language!")
    end
    tokens = []
    until @code.empty?
      tokens.append(tokenize_single)
      @code = @code.strip
    end
    tokens
  end

  Token = Struct.new(:type, :value)

  def tokenize_single
    case @lang
    when "python"
      PYTHON_TOKENS.each do |type, regex|
        # Match regexes at the start of @code (\A)
        regex = /\A(#{regex})/
        if @code.match(regex)
          value = $1
          @code.delete_prefix!(value)
          return Token.new(type, value)
        end
      end
    when "java"
      JAVA_TOKENS.each do |type, regex|
        # Match regexes at the start of @code (\A)
        regex = /\A(#{regex})/
        if @code.match(regex)
          value = $1
          @code.delete_prefix!(value)
          return Token.new(type, value)
        end
      end
    when "javascript"
      JS_TOKENS.each do |type, regex|
        # Match regexes at the start of @code (\A)
        regex = /\A(#{regex})/
        if @code.match(regex)
          value = $1
          @code.delete_prefix!(value)
          return Token.new(type, value)
        end
      end
    else
      raise RuntimeError, ("Code could not be tokenized.")
    end
    raise RuntimeError, (
      "Unrecognized token: #{@code.inspect}"
    )
  end
end
py_tokenizer = Tokenizer.new(File.read("test/tokenizer_tests/py_test.txt"))
tokens = py_tokenizer.tokenize
puts "Detected language: #{py_tokenizer.lang || "unknown lang"}"
puts tokens.map(&:inspect).join("\n")
puts("\n")
java_tokenizer = Tokenizer.new(File.read("test/tokenizer_tests/java_test.txt"))
tokens = java_tokenizer.tokenize
puts "Detected language: #{java_tokenizer.lang || "unknown lang"}"
puts tokens.map(&:inspect).join("\n")
puts("\n")
js_tokenizer = Tokenizer.new(File.read("test/tokenizer_tests/js_test.txt"))
tokens = js_tokenizer.tokenize
puts "Detected language: #{js_tokenizer.lang || "unknown lang"}"
puts tokens.map(&:inspect).join("\n")
puts("\n")
end
