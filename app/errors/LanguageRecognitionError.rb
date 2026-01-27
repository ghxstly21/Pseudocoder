module Compiler
  class LanguageRecognitionError < StandardError
    attr_reader :count_dict
    def initialize(message, count_list)
      super(message)
      @count_dict = count_list
    end
  end
end
