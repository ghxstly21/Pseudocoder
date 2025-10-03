class Tokenizer
  PYTHON_TOKENS = [
    [:and, /\band\b/],
    [:as, /\bas\b/],
    [:assert, /\bassert\b/],
    [:async, /\basync\b/],
    [:await, /\bwait\b/],
    [:break, /\bbreak\b/],
    [:case, /\bcase\b/],
    [:class, /\bclass\b/],
    [:continue, /\bcontinue\b/],
    [:def, /\bdef\b/],
    [:del, /\bdel\b/],
    [:elif, /\belif\b/],
    [:else, /\belse\b/],
    [:except, /\bexcept\b/],
    [:False, /\bFalse\b/],
    [:finally, /\bfinally\b/],
    [:for, /\bfor\b/],
    [:from, /\bfrom\b/],
    [:global, /\bglobal\b/],
    [:if, /\bif\b/],
    [:import, /\bimport\b/],
    [:in, /\bin\b/],
    [:is, /\bis\b/],
    [:lambda, /\blambda\b/],
    [:match, /\bmatch\b/],
    [:None, /\bNone\b/],
    [:nonlocal, /\bnonlocal\b/],
    [:not, /\bnot\b/],
    [:or, /\bor\b/],
    [:pass, /\bpass\b/],
    [:raise, /\braise\b/],
    [:return, /\breturn\b/],
    [:True, /\bTrue\b/],
    [:try, /\btry\b/],
    [:while, /\bwhile\b/],
    [:with, /\bwith\b/],
    [:yield, /\byield/],
    [:colon, /:/],
    [:identifier, /\b[a-zA-Z]+\b/],
    [:numbers, /\b[0-9]+\b/],
    [:open_paren, /\(/],
    [:close_paren, /\)/]
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