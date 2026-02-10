require_relative "ast"
require_relative "../../errors/UnsupportedLanguageError"
require_relative "../../errors/SyntaxError"

module Compiler
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
        case peek_type
        when :function
          nodes << parse_def
        when :if, :else, :while
          parse_conditional
        end
      end
      nodes
    end

    def parse_conditional
      condition_type = peek_type

      case condition_type
      when :if then parse_if
      when :else then raise("Line #{peek_token.location.line}, Column #{peek_token.location.column}\nFound 'else' with no matching 'if'.")
      when :while then parse_while
      else raise "Currently unsupported conditional at #{consume!(condition_type).location}"
      end
    end

    def parse_if
      body = []
      if_start = consume!(:if).location
    condition = parse_binary_expr
    if @lang == "python"
      consume!(:colon)
    else
      consume!(:open_brace)
    end
    until peek?(:close_brace)
      case peek_type
      when :function
        raise SyntaxError, "Unexpected function definition inside if statement."
      when :else, :elif
        raise SyntaxError, "Unexpected 'else' inside if statement body"
      when :if
        body << parse_if
      else
        body << parse_expr
      end
    end
      if_end = consume!(:close_brace).location
      if peek?(:else)
        else_body = parse_else
        IfNode.new(condition, body, loc_range(if_start, if_end), else_body)
      end
      IfNode.new(condition, body, loc_range(if_start, if_end))
    end

    def parse_else
      body = []
      consume!(:else)
      if @lang == "python"
        consume!(:colon)
      else
        if peek?(:if)
          return parse_if
        end
        consume!(:open_brace)
      end
      until peek?(:close_brace)
        case peek_type
        when :function
          raise SyntaxError, "Unexpected function definition inside if statement."
        when :else, :elif
          raise SyntaxError, "Unexpected 'else' inside else statement body"
        when :if
          body << parse_if
        else
          body << parse_expr
        end
      end
      body
    end

    def parse_while
      while_start = consume!(:while).location
      condition = parse_binary_expr
      if @lang == "python"
        consume!(:colon)
      else
        consume!(:open_brace)
      end
      until peek?(:close_brace)
        case peek_type
        when :function
          raise SyntaxError, "Unexpected function definition inside if statement."
        when :else, :elif
          raise SyntaxError, "Unexpected 'else' inside while loop body"
        when :if
          body << parse_if
        when :continue
          body << parse_continue
        when :break
          body << parse_break
        when :while
          body << parse_while
        else
          body << parse_expr
        end
      end
      while_end = consume!(:close_brace).location
      WhileNode.new(condition, body, LocationRange.new(while_start, while_end))
    end

    def parse_continue
      token = consume!(:continue)
      ContinueNode.new(token.value, (token.location))
    end

    def parse_binary_expr(min_bp = 0)
      operators = [ :add, :sub, :multiply, :divide, :and, :or, :comparison ]
      left = parse_expr
      while operators.include?(peek_type)
        operator_token = peek_token
        operator = operator_token.value
        left_bp, right_bp = binding_power(operator)
        break if left_bp < min_bp
        consume!(peek_type)
        right = parse_binary_expr(right_bp)
        left = BinaryExprNode.new(left, operator.value, right, LocationRange.new(left.location.start_loc, right.location.end_loc))
      end
      left
    end

    def binding_power(operator)
      case operator
      when "or", "||" then [ 1, 2 ]
      when "and", "&&" then [ 3, 4 ]
      when "<", ">", "==", "!=", "===" then [ 5, 6 ]
      when "+", "-" then [ 7, 8 ]
      when "*", "/" then [ 9, 10 ]
      else raise "Expected an operator (char) when getting binding power, got #{operator.class}"
      end
    end

    def parse_def
      case @lang

      when "python"

      when "java"

      when "javascript"
                    # function foo(arg1, arg2) {body}
                    consume!(:function)
                    token = consume!(:identifier)
                    name = token.value
                    arg_names = parse_args
                    consume!(:open_brace)
                    body = peek?(:close_brace) ? ExpressionNode.new(consume!(:close_brace).location) : parse_expr
                    consume!(:close_brace) if peek_type == :close_brace
                    FunctionNode.new(name, arg_names, body, token.location)
      else raise UnsupportedLanguageError, "parse_def expected a valid language, got #{@lang}."
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
      case peek_type
      when :exponential, :float, :integer
        parse_number
      when :identifier
        if peek?(:open_paren, 1)
          parse_call
        else
          parse_var_ref
        end
      when :open_paren
        consume!(:open_paren)
        expr = parse_binary_expr
        consume!(:close_paren)
        expr
      else
        raise SyntaxError, "Expected a valid expression."
      end
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

    def peek_token(offset = 0)
      @tokens.fetch(offset)
    end

    def loc_range(node_1, node_2)
        LocationRange.new(node_1.location.start_loc, node_2.location.end_loc)
    end
  end
end
