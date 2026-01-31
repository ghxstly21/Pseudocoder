module Compiler
  require_relative "../../errors/UnsupportedLanguageError"
  require_relative "../../errors/SyntaxError.rb"
  class Parser
    # Goal:
    # Produce a tree of nodes with 3 parts
    # Ex:
    # DEF/FUNCTION_NODE
    #   Name: "f"
    #   Args: ["x", "y", "z"]
    #   BODY:
    #     INTEGER_LITERAL: "1"

    FunctionNode = Struct.new(:name, :arg_names, :body)
    IntegerNode = Struct.new(:value)
    FloatNode = Struct.new(:value)
    ExponentialNode = Struct.new(:value)
    CallNode = Struct.new(:name, :arg_exprs)
    VarRefNode = Struct.new(:value)

    def initialize(tokens, lang)
      @tokens = tokens
      @lang = lang
    end
    def parse
      case @lang
      when "python" then parse_python
      when "java" then parse_java
      when "javascript" then parse_js
      else raise UnsupportedLanguageError, "Parser expected a valid language, got #{@lang}."
      end
    end

    private

    def parse_python
    end

    def parse_java
    end

    def parse_js
      until @tokens.empty?
        if peek?(:function)
          parse_def
        end
      end
    end
    def parse_def
      case @lang
      when "python"
        then
      when "java"
        then
      when "javascript"
      then
                    # function foo(arg1, arg2) {body}
                    consume!(:function)
                    name = consume!(:identifier).value
                    arg_names = parse_args
                    body = parse_expr
                    FunctionNode.new(name, arg_names, body)
      else raise LanguageRecognitionError, "parse_def expected a valid language, got #{@lang}."
      end
      end
    def parse_args
      args = []
      consume!(:open_paren)
      if peek?(:identifier)
        args << consume!(:identifier).value
        while peek?(:comma)
          consume!(:comma)
          args << consume!(:identifier).value
        end
      end
      consume!(:close_paren)
      args
      end
    def parse_expr
      consume!(:open_brace)
      if [ :exponential, :float, :integer ].include? peek_type
        body = parse_number
      elsif peek?(:identifier) && peek?(:open_paren, 1)
        body = parse_call
      else
        body = parse_var_ref
      end
      consume!(:close_brace)
      body
      end

    def parse_number
      num_type = peek_type

      case num_type
      when :exponential then ExponentialNode.new(consume!(:exponential).value.to_f)
      when :float then FloatNode.new(consume!(:float).value.to_f)
      when :integer then IntegerNode.new(consume!(:integer).value.to_i)
      else
        raise SyntaxError, "Expected an integer, float, or scientific notation number, but got #{num_type}."
      end
    end

      def parse_call
        # f(x, y, z)
        name = consume!(:identifier).value
        consume! :open_paren
        arg_exprs = []
        consume! :close_paren
        CallNode.new(name, arg_exprs)
      end

    def parse_arg_exprs
      arg_exprs = []
      consume!(:open_paren)
      unless peek?(:close_paren)
        arg_exprs << consume!(:identifier).value
        while peek?(:comma)
          consume!(:comma)
          arg_exprs << consume!(:identifier).value
        end
      end
      consume!(:close_paren)
      arg_exprs
    end

    def parse_var_ref
      VarRefNode.new(consume!(:identifier))
    end

    def consume!(expected_type)
      # Grab the first token from the list and remove it
      token = @tokens.shift
      if token.type == expected_type
        token
      else
        raise SyntaxError.new(
          "Expected #{expected_type.inspect} but got #{token.type.inspect}"
        )
      end
    end
      def peek?(expected_type, offset = 0)
          @tokens.fetch(offset).type == expected_type
        end

    def peek_type(offset = 0)
      @tokens.fetch(offset).type
    end
  end
end
