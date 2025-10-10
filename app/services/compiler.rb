class Tokenizer
  # MISSING COMPARISON OPERATIONS FOR ALL LANGS
  PYTHON_TOKENS = [
    [ :and, /\band\b/ ],
    [ :break, /\bbreak\b/ ],
    [ :case, /\bcase\b/ ],
    [ :class, /\bclass\b/ ],
    [ :continue, /\bcontinue\b/ ],
    [ :def, /\bdef\b/ ],
    [ :elif, /\belif\b/ ],
    [ :else, /\belse\b/ ],
    [ :except, /\bexcept\b/ ],
    [ :finally, /\bfinally\b/ ],
    [ :for, /\bfor\b/ ],
    [ :if, /\bif\b/ ],
    [ :in, /\bin\b/ ],
    [ :is, /\bis\b/ ],
    [ :lambda, /\blambda\b/ ],
    [ :not, /\bnot\b/ ],
    [ :or, /\bor\b/ ],
    [ :raise, /\braise\b/ ],
    [ :return, /\breturn\b/ ],
    [ :try, /\btry\b/ ],
    [ :while, /\bwhile\b/ ],
    [ :yield, /\byield/ ],
    [ :colon, /:/ ],
    [ :identifier, /\b[a-zA-Z]+\b/ ],
    [ :number, /\b[0-9]+\b/ ],
    [ :open_paren, /\(/ ],
    [ :close_paren, /\)/ ],
    [ :add, /\b\+\b/ ],
    [ :sub, /\b-\b/ ],
    [ :multiply, /\b\*\b/ ],
    [ :divide, /\b\/\b/ ],
    [ :operator, /[+\-*\/]/ ]
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
  [ :identifier, /\b[a-zA-Z]+\b/ ],
  [ :numbers, /\b[0-9]+\b/ ],
  [ :open_paren, /\(/ ],
  [ :close_paren, /\)/ ]
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
  [ :identifier, /\b[a-zA-Z]+\b/ ],
  [ :numbers, /\b[0-9]+\b/ ],
  [ :open_paren, /\(/ ],
  [ :close_paren, /\)/ ]
]

  def initialize(code)
    @code = code
  end
  def identify_lang
    lang = "x"
    # Find if its python, java, or js or raise an exception if it's not any
    raise RuntimeError("Language could not be recognized as Java, Python, or Javascript")
  end
  def tokenize
    tokens = []
    until @code.empty?
      tokens.append(tokenize_single)
      @code = @code.strip
    end
  end
  def tokenize_single
    PYTHON_TOKENS.each do |type, regex|
      # Match regexes at the start of @code (\A)
      regex = /\A(#{regex})/
      if @code.match(regex)
        value = $1 # .to_s?
        @code = @code[value.length..-1]
        return Token.new(type, value)
      end
    end
    raise RuntimeError, (
      "Unrecognized token: #{@code.inspect}"
    )
  end

  Token = Struct.new(:type, :value)
  tokens = Tokenizer.new(File.read("app/services/test.txt")).tokenize
  puts tokens.map(&:inspect).join("\n")
end
