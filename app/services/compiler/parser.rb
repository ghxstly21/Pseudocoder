module COMPILER
  class Parser
    @lang
    def initialize(tokens, lang)
      @tokens = tokens
      @lang = lang
    end
    def parse
      parse_def
    end
    def parse_def
      name = consume(:identifier).value
      arg_names = parse_args
      if @lang == "java" || @lang == "javascript"
        consume(:open_brace)
        body = parse_expr
        consume(:close_brace)
      elsif @lang == "python"
        # BUG: python should be able to detect indentation
      else
        raise RuntimeError("Unrecognized language: #{@lang}")
      end
      # Begin AST creation
      case
      when @lang == "java"
        # BUG: need to recognize java method calls
      when @lang == "javascript" || @lang == "python"
        function_node = Tree.new(:function, [ arg_names, body ])
      else
        raise RuntimeError("Unrecognized language: #{@lang}")
      end
    def parse_args
      consume(:open_paren)
      consume(:close_paren)
    end
    def parse_expr
      parse_number
    end

    def parse_number
      consume(:number)
    end

    def consume(expected_type)
      # Grab the first token from the list and remove it
      token = tokens.slice!(0)
      if token.type == expected_type
        token
      else
        raise RuntimeError.new(
          "Expected token type #{expected_type.inspect} but got #{token.type.inspect}"
        )
      end

    end
  end
  end
  end
