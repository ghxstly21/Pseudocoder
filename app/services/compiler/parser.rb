require_relative "ast"
require_relative "../../errors/compiler/unsupported_language_error"
require_relative "../../errors/compiler/syntax_error"

module Compiler
  # noinspection RubyTooManyMethodsInspection
  class Parser # Goal: Produce a tree of nodes with 3 parts
    # Ex:
    # DEF/FUNCTION_NODE
    # Name: "f"
    # Args: %w[x y z]
    # BODY:
    # INTEGER_LITERAL: "1"
    JAVA_TYPES = %i[var char byte short int long float double bool string_type void]
    attr_accessor :ast
    def initialize(tokens, lang)
      @tokens = tokens
      @lang = lang
      @ast = []
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
      until @tokens.empty?
        modifiers = parse_modifiers
        case peek_type
        when :class then @ast << parse_class(modifiers)
        when :identifier, *JAVA_TYPES
          if peek?(:identifier, 1) && peek?(:open_paren, 2)
            @ast << parse_def(modifiers)
          else
            @ast << parse_var_set
          end
        when :if, :else, :while, :for
          @ast << parse_conditional
        else
          raise SyntaxError, "#{peek_token.location}Unknown type: #{peek_token.type}"
        end
      end
    end

    def parse_js
      until @tokens.empty?
        case peek_type
        when :function
          @ast << parse_def
        when :if, :else, :while, :for
          @ast << parse_conditional
        else
          raise "Unsupported node type by parse_js: #{peek_type}"
        end
      end
      @ast
    end

    def parse_class(modifiers)
      # [modifiers] class identifier {}
      #       supported_keywords = %i[class]
      class_start = consume!(:class).location
      name = consume!(:identifier).value
      body = []
      consume!(:open_brace)
      until peek?(:close_brace)
        if JAVA_TYPES.include?(peek_type)
          # int -> num = 0;
          i = 0
          while peek?(:dot)
          parse_var_set if peek?(:identifier, 1) && peek?(:assignment, 2)
          end
        end
      end
      end

    def parse_modifiers
      parsed_modifiers = []
      modifiers = %i[public private protected abstract final static]
      i = 0
      while modifiers.include?(peek_type(i))
        parsed_modifiers << consume!(peek_type(i)).type
        i += 1
      end
      parsed_modifiers
    end

    def keywords_conflict?(node)
      # return true if the code contains multiple access modifiers
      access_modifiers = %i[public private protected]
      return true if node.modifiers.count { access_modifiers.include?(it) } > 1

      if node.modifiers.include?(:abstract)
        abstract_conflicts = %i[final native synchronized strictfp]
        return true if node.modifiers.any? { abstract_conflicts.include?(it) }
        if node.is_a?(FunctionNode)
          return true if node.modifiers.any? { %i[private static].include?(it) }
        end
      end

      if node.modifiers.include?

      end
      end

    def parse_conditional
      condition_type = peek_type

      case condition_type
      when :if then parse_if
      when :else then raise("Line #{peek_token.location.line}, Column #{peek_token.location.column}\nFound 'else' with no matching 'if'.")
      when :while then parse_while
      when :for then parse_for
      else raise "Currently unsupported conditional at #{consume!(condition_type).location}"
      end
    end

    def parse_if
      body = []
      if_start = consume!(:if).location
      consume!(:open_paren)
      condition = parse_binary_expr
      consume!(:close_paren)
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
      when :return
        body << parse_return
      else
        body << parse_expr
      end
    end
      if_end = consume!(:close_brace).location
      if peek?(:else)
        else_body = parse_else
        IfNode.new(condition, body, LocationRange.new(if_start, if_end), else_body)
      else
      IfNode.new(condition, body, LocationRange.new(if_start, if_end))
      end
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
        when :return
          body << parse_return
        else
          body << parse_expr
        end
      end
      consume!(:close_brace)
      body
    end

    def parse_while
      while_start = consume!(:while).location
      consume!(:open_paren)
      condition = parse_binary_expr
      consume!(:close_paren)
      body = []
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
        when :return
          body << parse_return
        else
          body << parse_expr
        end
      end
      while_end = consume!(:close_brace).location
      WhileNode.new(condition, body, LocationRange.new(while_start, while_end))
    end

    def parse_for
      body = []
      unary_exprs = %i[increment decrement]
      allowed_steps = %i[add_assign sub_assign mul_assign div_assign]
      allowed_types = %i[let var const byte short int long]
      # for(let/var i = 0; i < 10; i++) {}
      # for(let/const/var variable of/in list) {}
      # for(int i = 0; i < 10; i++) {}
      # for(identifier i : list) {}
      #
      # for i in _
      for_start = consume!(:for).location
      consume!(:open_paren)
      raise SyntaxError, "#{for_start}Expected variable initialization" unless allowed_types.include?(peek_type)
      init_node = parse_var_set
      comparison = parse_binary_expr
      consume!(:semicolon)
      # ++i i++ i += 3
      if unary_exprs.include?(peek_type) ||
         unary_exprs.include?(peek_type(1))
        increment = parse_unary_expr
      elsif allowed_steps.include?(peek_type(1))
        increment = parse_binary_expr
      else
        raise SyntaxError, "#{for_start}\nUnknown increment in loop"
      end
      consume!(:close_paren)
      consume!(:open_brace)
      # body
      until peek?(:close_brace)
        case peek_type
        when :function
          raise SyntaxError, "Unexpected function definition inside if statement."
        when :else, :elif
          raise SyntaxError, "Unexpected 'else' inside for loop body"
        when :if
          body << parse_if
        when :continue
          body << parse_continue
        when :break
          body << parse_break
        when :while
          body << parse_while
        when :return
          body << parse_return
        else
          body << parse_expr
        end
      end

      for_end = consume!(:close_brace).location
      ForNode.new(
        init_node,
        comparison,
        increment,
        body,
        LocationRange.new(for_start, for_end)
      )
    end

    def parse_break
      token = consume!(:break)
      BreakNode.new(token.value, token.location)
    end

    def parse_continue
      token = consume!(:continue)
      ContinueNode.new(token.value, token.location)
    end

    def parse_binary_expr(min_bp = 0)
      operators = %i[ add sub multiply divide and or comparison add_assign sub_assign mul_assign div_assign ]
      left = parse_expr
      while operators.include?(peek_type)
        operator_token = peek_token
        operator = operator_token.value
        left_bp, right_bp = binding_power(operator)
        break if left_bp < min_bp
        consume!(peek_type)
        right = parse_binary_expr(right_bp)
        left = BinaryExprNode.new(left, operator, right, LocationRange.new(left.location, right.location))
      end
      left
    end

    def binding_power(operator)
      case operator
      when "+=", "-=", "*=", "/=" then [ 1, 0 ]
      when "or", "||" then [ 1, 2 ]
      when "and", "&&" then [ 3, 4 ]
      when "<", ">", "<=", ">=", "==", "!=", "===" then [ 5, 6 ]
      when "+", "-" then [ 7, 8 ]
      when "*", "/", "%" then [ 9, 10 ]
      else raise "Expected an operator (char) when getting binding power, got #{operator.class}"
      end
    end

    def parse_def(modifiers = nil)
      case @lang

      when "python"

      when "java"
              # [modifiers] type name(type1 arg1, type2 arg2) {body}
              if supported_types.include?(peek_type)
                type_token = consume!(peek_type)
                def_start = type_token.location
                return_type = type_token.value
              else
                raise SyntaxError, "#{peek_token.location}Expected function's return type, got '#{peek_token.value}'"
              end

              name = consume!(:identifier).value
              args = parse_args
              consume!(:open_brace)
              body = []
              until peek?(:close_brace)
                local_modifiers = parse_modifiers

                case peek_type
                when :class then body << parse_class(local_modifiers)
                when :identifier, *JAVA_TYPES
                  if peek?(:identifier, 1) && peek?(:open_paren, 2)
                    raise SyntaxError, "#{peek_token(1).location}Unexpected function definition inside method body."
                  else
                    body << parse_var_set
                  end
                when :if, :else, :while, :for
                  body << parse_conditional
                when :return
                  body << parse_return
                else
                  body << parse_expr
                end
              end

              def_end = consume!(:close_brace).location
              func = FunctionNode.new(
                name,
                args,
                body,
                LocationRange.new(def_start, def_end),
                return_type,
                modifiers
              )
              raise SyntaxError, "#{func.location}Function contains conflicting modifiers." if keywords_conflict?(func)
      # continue working on parse_def, add in keywords_conflict? to different
      # functions
      when "javascript"
                    # function foo(arg1, arg2) {body}
                    def_start = consume!(:function).location
                    token = consume!(:identifier)
                    name = token.value
                    arg_names = parse_args
                    consume!(:open_brace)
                    body = []
                    until peek?(:close_brace)
                      if %i[if else while for].include?(peek_type)
                        body << parse_conditional
                      elsif peek?(:return)
                        body << parse_return
                      else
                        body << parse_expr
                      end
                    end
                    def_end = consume!(:close_brace).location
                    FunctionNode.new(
                      name,
                      arg_names,
                      body,
                      LocationRange.new(def_start, def_end)
                    )
      else raise UnsupportedLanguageError, "parse_def expected a valid language, got #{@lang}."
      end
      end
    def parse_args
      args = []
      consume!(:open_paren)
      case @lang
      when "javascript"
        unless peek?(:close_paren)
        if peek?(:identifier)
          arg_token = consume!(:identifier)
          args << ArgNode.new(arg_token.value, arg_token.location)
          while peek?(:comma)
            consume!(:comma)
            arg_token = consume!(:identifier)
            args << ArgNode.new(arg_token.value, arg_token.location)
          end
        end
        end
      when "java"

        unless peek?(:close_paren)
        args << parse_java_arg

        while peek?(:comma)
          consume!(:comma)
          args << parse_java_arg
        end
        end
      else
        raise UnsupportedLanguageError, "Expected Java or JavaScript, got #{@lang}."
      end
      consume!(:close_paren)
      args
    end

    def parse_java_arg
      type_token = consume!(peek_type)
      arg_start = type_token.location
      arg_type = type_token.value

      unless JAVA_TYPES.include?(peek_type)
        raise SyntaxError, "#{peek_token.location}Expected a valid type." unless peek?(:identifier)
        while peek?(:dot)
          arg_type << consume!(:dot).value
          arg_type << consume!(:identifier).value
        end
      end

      arg_token = consume!(:identifier)
      arg_end = arg_token.location
      ArgNode.new(arg_token.value, LocationRange.new(arg_start, arg_end), arg_type)
    end
    def parse_expr
      case peek_type
      when :let, :var, :const
        parse_var_set
      when :exponential, :float, :integer
        parse_number
      when :identifier
        i = 1
        while peek?(:dot, i)
          raise SyntaxError, "Expected identifier after '.'" unless peek?(:identifier, i+1)
          i += 2
        end
        if peek?(:open_paren, i)
          parse_call
        elsif peek?(:assignment, i)
          parse_assignment
        elsif [ :increment, :decrement ].include?(peek_type(i))
          parse_unary_expr
        else
          parse_var_ref
        end
      when :not, :increment, :decrement
        parse_unary_expr
      when :open_paren
        consume!(:open_paren)
        expr = parse_binary_expr
        consume!(:close_paren)
        expr
      when :open_bracket
        parse_arr
      when :string
        parse_str
      else
        raise SyntaxError, "Expected a valid expression, got #{peek_type}."
      end
    end

    def parse_var_set
      # let x = 5
      # let y = "hello"
      # const x = "var";
      # var x = 5;
      # int, long, string, char, short, float, double
      if @lang == "javascript"
        js_modifiers = %i[var let const]
        modifiers = []
        init_start = peek_token.location
        modifiers << consume!(:identifier).value if peek_token.value == "export"
        if js_modifiers.include? peek_type
          modifiers << consume!(peek_type).value
        else
          return parse_assignment
        end
        name = parse_var_ref.value
        consume!(:assignment)
        value = parse_binary_expr
        init_end = value.location
        if peek?(:semicolon)
          init_end = consume!(:semicolon).location
        end
        DeclarationNode.new(modifiers, name, value, LocationRange.new(init_start, init_end))
      elsif @lang == "java"
        # int num = 0;
        # ArrayList<Integer> a = new ArrayList<>();
        modifiers = [] if modifiers.nil?
        supported_types = %i[var char byte short int long float double bool string_type void]
        if supported_types.include?(peek_type)
          init_start = peek_token.location
          var_type = consume!(peek_type).type
        else
          return parse_assignment
        end
        name = parse_var_ref.value
        consume!(:assignment)
        value = parse_expr
        init_end = consume!(:semicolon).location
        DeclarationNode.new(modifiers, name, value, LocationRange.new(init_start, init_end), data_type)
      end
    end

    def parse_assignment
      # x = 5
      name_token = consume!(:identifier)
      name = name_token.value
      assignment_start = name_token.location
      consume!(:assignment)
      value = parse_expr
      assignment_end = value.location
      if peek?(:semicolon)
        assignment_end = consume!(:semicolon).location
      end
      AssignmentNode.new(name, value, LocationRange.new(assignment_start, assignment_end))
    end

    def parse_unary_expr
      if peek?(:not)
        is_prefix = true
        not_token = consume!(:not)
        unary_start = not_token.location
        operator = not_token.value
        expr = parse_binary_expr(11) # not has the highest BP
        unary_end = expr.location
        # pre-increment -> ++x
      elsif [ :increment, :decrement ].include?(peek_type)
        is_prefix = true
        operator_token = consume!(peek_type)
        unary_start = operator_token.location
        operator = operator_token.value
        expr = parse_var_ref
        unary_end = expr.location
      else
        is_prefix = false
        # post-increment -> x++
        expr = parse_var_ref
        unary_start = expr.location
        operator_token = consume!(peek_type)
        unary_end = operator_token.location
        operator = operator_token.value
      end
      if @lang == "java" && !peek?(:semicolon)
        raise SyntaxError, "#{unary_end}Expected ';'"
      end
      unary_end = consume!(:semicolon).location if peek?(:semicolon)
      UnaryExprNode.new(expr, operator, LocationRange.new(unary_start, unary_end), is_prefix: is_prefix)
    end

    def parse_return
      return_start = consume!(:return).location
      raise SyntaxError, "Unexpected 'return' after return statement" if peek?(:return)
      value = parse_binary_expr
      return_end = value.location
      if @lang == "java" && !peek?(:semicolon)
        raise SyntaxError, "#{return_end}Expected ';'"
      end
      return_end = consume!(:semicolon).location if peek?(:semicolon)
      RetNode.new(value, LocationRange.new(return_start, return_end))
    end

    def parse_arr
      arr = []
      if @lang == "java"
        arr_symbol = :open_brace
      else
        arr_symbol = :open_bracket
      end
      closing_symbol =
        {
          open_bracket: :close_bracket,
          open_brace: :close_brace
        }
      arr_start = consume!(arr_symbol).location
      unless peek?(closing_symbol[arr_symbol])
        arr << parse_expr
        while peek?(:comma)
          consume!(:comma)
          arr << parse_expr
        end
      end
      arr_end = consume!(closing_symbol[arr_symbol]).location
      if @lang == "java" && !peek?(:semicolon)
        raise SyntaxError, "#{arr_end}Expected ';'"
      end
      arr_end = consume!(:semicolon).location if peek?(:semicolon)
      ArrDeclNode.new(arr, LocationRange.new(arr_start, arr_end))
    end

    def parse_str
      str_token = consume!(:string)
      StringNode.new(str_token.value, str_token.location)
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
        name_token = consume!(:identifier)
        call_start = name_token.location
        name = name_token.value
        while peek?(:dot)
          name << consume!(:dot).value
          name << consume!(:identifier).value
        end
        arg_exprs = parse_arg_exprs
        CallNode.new(name, arg_exprs, call_start)
      end

    def parse_arg_exprs
      arg_exprs = []
      consume!(:open_paren)

      unless peek?(:close_paren)
        arg_exprs << parse_binary_expr
        while peek?(:comma)
          consume!(:comma)
          arg_exprs << parse_binary_expr
        end
      end
      consume!(:close_paren)
      arg_exprs
    end

    def parse_var_ref
      var_token = consume!(:identifier)
      value = var_token.value
      while peek?(:dot)
        value << consume!(:dot).value
        value << consume!(:identifier).value
      end
      VarRefNode.new(value, var_token.location)
    end

    # HELPER METHODS
    # Allow us to view the next token
    # Also allows us to remove it from the token list as well

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
  end
end
