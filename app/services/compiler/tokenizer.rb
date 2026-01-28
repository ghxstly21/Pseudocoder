module Compiler
  require "set"
  require_relative "../../errors/UnsupportedLanguageError"
  require_relative "../../errors/LanguageRecognitionError"
  require_relative "../../errors/TokenError"
class Tokenizer

  Token = Struct.new(:type, :value)

  def initialize(path_or_code, from_file: true)
    if from_file
      @lang = case File.extname @code
              when ".py" then "python"
              when ".java" then "java"
              when ".js" then "javascript"
              else raise UnsupportedLanguageError, "Expected a .java, .js, or .py file but got #{File.extname @code}."
              end
      @code = File.read(path_or_code)
    else
      begin
        identify_lang
      rescue LanguageRecognitionError => lang_error
        @lang_error = lang_error
        puts("ERROR: #{lang_error.message}\nLanguage Counts: #{lang_error.count_dict}")
        return []
      end
      @code = path_or_code
    end

    @token_defs = case @lang
                 when "python" then PYTHON_TOKENS
                 when "java" then JAVA_TOKENS
                 when "javascript" then JS_TOKENS
                 else raise TokenError.new("Code could not be tokenized."), cause: @lang_error  # token error with cause
                 end
  end

  attr_reader :code, :lang
  PYTHON_TOKENS = [
    [ :and, /\band\b/ ],
    [ :break, /\bbreak\b/ ],
    [ :case, /\bcase\b/ ],
    [ :class, /\bclass\b/ ],
    [ :continue, /\bcontinue\b/ ],
    [ :function, /\bdef\b/ ],
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
    [ :comment, /#.*/ ],
  [ :identifier, /\b[A-Za-z_][A-Za-z0-9_]*\b/ ],
    [ :number, /\b[0-9]+\b/ ],
    [ :open_paren, /\(/ ],
    [ :close_paren, /\)/ ],
    [ :comparison, /(==|!=|>=|<=|>|<)/ ],
    [ :floor_div_assign, /\/\/=/ ],  # //=
    [ :pow_assign, /\*\*=/ ],        # **=
    [ :add_assign, /\+=/ ],
    [ :sub_assign, /-=/ ],
    [ :mul_assign, /\*=/ ],
    [ :div_assign, /\/=/ ],
    [ :floor_div, /\/\// ],
    [ :pow, /\*\*/ ],
    [ :add, /\+/ ],
    [ :sub, /-/ ],
    [ :multiply, /\*/ ],
    [ :divide, /\// ],
    [ :assignment, /=/ ],
    [ :string, /"(\\.|[^"\\])*"/ ],
    [ :string, /'(\\.|[^'\\])*'/ ]
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
    [ :comment, /\/\/.*/ ],
    [ :comment, /\/\*[\s\S]*?\*\// ],
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
  [ :comment, /\/\/.*/ ],
  [ :comment, /\/\*[\s\S]*?\*\// ],
  [ :string, /"(\\.|[^"\\])*"/ ],
  [ :string, /`([^`\\]|\\.)*`/ ],
  [ :open_brace, /\{/ ],
  [ :close_brace, /}/ ],
  [ :open_bracket, /\[/ ],
  [ :close_bracket, /\]/ ],
  [ :semicolon, /;/ ],
  [ :dot, /\./ ],
  [ :comma, /,/ ],
  [ :const, /\bconst\b/ ],
  [ :identifier, /[A-Za-z_][A-Za-z0-9_]*/ ],
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
  # Sets lang to the language of the file, and then returns it.
  def identify_lang
    py_regexes = PYTHON_TOKENS.map { |pair| pair[1] }.to_set
    java_regexes = JAVA_TOKENS.map { |pair| pair[1] }.to_set
    js_regexes = JS_TOKENS.map { |pair| pair[1] }.to_set
    # creates a set of all regexes in common within 2 or more languages
    general_tokens =
      (java_regexes & py_regexes | java_regexes & js_regexes | py_regexes & js_regexes)
    # creates language specific regexp sets
    py_exclusive = py_regexes - general_tokens
    java_exclusive = java_regexes - general_tokens
    js_exclusive = js_regexes - general_tokens
    # counts the number of matches for each language in @code
    python_count = py_exclusive.count { |regexp| @code.match?(regexp) }
    java_count = java_exclusive.count { |regexp| @code.match?(regexp) }
    js_count = js_exclusive.count { |regexp| @code.match?(regexp) }
    count_list = {
      "python" => python_count,
      "java" => java_count,
      "javascript" => js_count
    }
    # sorted array of all counts from greatest to least
    values = count_list.values.sort.reverse
    # if only 1 count is the max, return the corresponding language
    unless values[1..].any? { |value| value == values[0] }
      @lang = count_list.key(values[0])
      return @lang
    end
    # raise an error if multiple languages had the same count
    raise LanguageRecognitionError.new("Language could not be identified. Please confirm it to continue compilation.", count_list)
  end
  def tokenize
    tokens = []
    unless @lang == "python"
      until @code.empty?
        token = tokenize_single
        @code = @code.strip
        tokens << token
      end
      return tokens
    end
     until @code.empty?
       # more explicit whitespace handling for python
       if @code.start_with?(" ") || @code.start_with?("\n") || @code.start_with?("\r")
         @code = @code.lstrip  # remove them
         next                  # don't recognize them as a token
       end
       begin
         token = tokenize_single
         tokens << token
       rescue TokenError => e
         puts "ERROR: Tokenization failed. #{e.message}"
         raise e # Tokenization failure
       end
       @code = @code.strip
     end
    tokens
    end
  def tokenize_single


    @token_defs.each do |type, regex|
      if (match = @code.match(/\A#{regex}/)) # assign match, check if truthy
        value = match[0] # matched text
        @code.delete_prefix!(value)  # cut off the token from @code
        return Token.new(type, value)
      end
    end
    raise TokenError, "Unrecognized token: #{@code.inspect}" # token error
  end

  # begin tokenization
  # py_tokenizer = Tokenizer.new(File.read("test/tokenizer_tests/py_test.txt"))
  # tokens = py_tokenizer.tokenize
  # puts "Detected language: #{py_tokenizer.lang || "unknown lang"}"
  # puts tokens.map(&:inspect).join("\n")
  # puts("\n")
  # java_tokenizer = Tokenizer.new(File.read("test/tokenizer_tests/java_test.txt"))
  # tokens = java_tokenizer.tokenize
  # puts "Detected language: #{java_tokenizer.lang || "unknown lang"}"
  # puts tokens.map(&:inspect).join("\n")
  # puts("\n")
  # js_tokenizer = Tokenizer.new(File.read("test/tokenizer_tests/js_test.txt"))
  # tokens = js_tokenizer.tokenize
  # puts "Detected language: #{js_tokenizer.lang || "unknown lang"}"
  # puts tokens.map(&:inspect).join("\n")
  # js_edge_case = Tokenizer.new(File.read("test/tokenizer_tests/js_edge_case.txt"))
  # tokens = js_edge_case.tokenize
  # puts "Lang: #{js_edge_case.lang}\nTokens: #{tokens}"
  # puts("\n")
  # # begin parsing
  # # NOTE: There should not be a new tokenizer for each language
  # # There should be one general tokenizer that takes in a user's file
  # # root = Parser.new(tokens, user_tokenizer.lang).parse()
  # root = Parser.new(tokens, py_tokenizer.lang).parse
  # puts root
end
end
