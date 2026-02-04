module Compiler
  require_relative "ast"
  require_relative "../../errors/UnsupportedLanguageError"
  require_relative "../../errors/SyntaxError"
  class Parser # Goal: Produce a tree of nodes with 3 parts
    # Ex:
    # DEF/FUNCTION_NODE
    # Name: "f"
    # Args: %w[x y z]
    # BODY:
    # INTEGER_LITERAL: "1"
    def initialize(tokens, lang)
      @tokens = tokens
      @lang = lang
    end
    def parse
      case @lang
      when "python" then ProgramNode.new(parse_python)
      when "java" then ProgramNode.new(parse_java)
      when "javascript" then ProgramNode.new(parse_js)
      else raise UnsupportedLanguageError, "Parser expected a valid language, got #{@lang}."
      end
    end

    private

    def parse_python
    end

    def parse_java
    end

    def parse_js
      nodes = []
      until @tokens.empty?
        if peek?(:function)
          nodes << parse_def
        end
      end
      nodes
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
                    token = consume!(:identifier)
                    name = token.value
                    arg_names = parse_args
                    body = parse_expr
                    FunctionNode.new(name, arg_names, body, token.location)
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
      token = consume!(num_type)
      value = num_type == :integer ? token.value.to_i : token.value.to_f
      case num_type
      when :integer then IntegerNode.new(value, token.location)
      when :float then FloatNode.new(value, token.location)
      when :exponential then ExponentialNode.new(value, token.location)
      else
        raise SyntaxError, "Line #{token.location.line}, Column #{token.location.column}\nExpected a number when parsing expression, but got #{num_type}"
      end
    end

      def parse_call
        # f(x, y, z)
        call_start = consume!(:identifier)
        name = call_start.value
        arg_exprs = parse_arg_exprs
        CallNode.new(name, arg_exprs, call_start.location)
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
      token = consume! :identifier
      VarRefNode.new(token.value, token.location)
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
