module Compiler
  require "set"
  require_relative "../../errors/UnsupportedLanguageError"
  require_relative "../../errors/LanguageRecognitionError"
  require_relative "../../errors/TokenError"

class Tokenizer
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
    [ :string, /"(\\.|[^"\\])*"/ ],
    [ :string, /'(\\.|[^'\\])*'/ ],
    [ :string, /("""|''')[\s\S]*?\1/ ],
    [ :comment, /#.*/ ],
    [ :comment, /("""|''')[\s\S]*?\1/ ],
    [ :exponential, /\b(\d+(?:_\d+)*(\.\d+(?:_\d+)*)?|\.\d+(?:_\d+)*)([eE][+-]?\d+(?:_\d+)*)\b/ ],
    [ :float, /\b(\d+\.\d*|\d*\.\d+)\b/ ],
    [ :integer, /\b[0-9]+\b/ ],
    [ :comma, /,/ ],
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
    [ :identifier, /\b[A-Za-z_][A-Za-z0-9_]*\b/ ]

  ]
  JAVA_TOKENS = [
    [ :comment, /\/\/.*/ ],
    [ :comment, /\/\*[\s\S]*?\*\// ],
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
    [ :exponential, /\b(\d+(?:_\d+)*(?:\.\d+(?:_\d+)*)?|\.\d+(?:_\d+)*)([eE][+-]?\d+(?:_\d+)*)\b/ ],
    [ :float, /\b(\d+(?:_\d+)*\.\d*(?:_\d+)*|\d*(?:_\d+)*\.\d+(?:_\d+)*)\b/ ],
    [ :integer, /\b\d+(?:_\d+)*\b/ ],
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
    [ :assignment, /=/ ],
    [ :identifier, /\b[A-Za-z_][A-Za-z0-9_]*\b/ ]
  ]
  JS_TOKENS = [
    [ :comment, /\/\/.*/ ],
    [ :comment, /\/\*[\s\S]*?\*\// ],
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
    [ :string, /`([^`\\]|\\.)*`/ ],
    [ :string, /'(\\.|[^'\\])*'/ ],
    [ :open_brace, /\{/ ],
    [ :close_brace, /}/ ],
    [ :open_bracket, /\[/ ],
    [ :close_bracket, /\]/ ],
    [ :semicolon, /;/ ],
    [ :dot, /\./ ],
    [ :comma, /,/ ],
    [ :const, /\bconst\b/ ],
    [ :exponential, /\b(\d+(?:\.\d+)?|\.\d+)[eE][+-]?\d+\b/ ],
    [ :float, /\b(\d+\.\d*|\.\d+)\b/ ],
    [ :integer, /\b\d+\b/ ],
    [ :open_paren, /\(/ ],
    [ :close_paren, /\)/ ],
    [ :add, /\+/ ],
    [ :sub, /-/ ],
    [ :multiply, /\*/ ],
    [ :divide, /\// ],
    [ :comparison, /(>=|<=|===|==|>|<)/ ],
    [ :assignment, /=/ ],
    [ :identifier, /[A-Za-z_][A-Za-z0-9_]*/ ]
  ]

  Token = Struct.new(:type, :value)
  LANG_TOKENS = {
    "python" => PYTHON_TOKENS,
    "java" => JAVA_TOKENS,
    "javascript" => JS_TOKENS
  }
  def initialize(path_or_code, from_file: true)
    if from_file
      @code = File.read path_or_code
      @lang = case File.extname path_or_code
      when ".py" then "python"
      when ".java" then "java"
      when ".js" then "javascript"
      else raise UnsupportedLanguageError, "Expected a .java, .js, or .py file but got #{File.extname @code}."
      end
    else
      @code = path_or_code
      identify_lang
    end
    @token_defs = LANG_TOKENS[@lang]
  end

  attr_reader :code, :lang

  def tokenize
    tokens = []
    unless @lang == "python"
      until @code.empty?
        token = tokenize_single
        @code = @code.strip
        tokens << token unless token.type == :comment
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

  private
  def tokenize_single
    @token_defs.each do |type, regex|
      if (match = @code.match(/\A#{regex}/)) # assign match, check if truthy
        value = match[0] # matched text
        @code.delete_prefix!(value) # cut off the token from @code
        return Token.new(type, value)
      end
    end
    raise TokenError, "Unrecognized token: #{@code.inspect}" # token error
  end


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
      @lang = count_list.key(values.fetch(0)) || raise("count_list.key returned nil at identify_lang")
      return @lang
    end
    # raise an error if multiple languages had the same count
    raise LanguageRecognitionError.new("Language could not be identified. Please confirm it to continue compilation.", count_list)
  end
end
end
