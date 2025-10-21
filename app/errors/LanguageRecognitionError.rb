module COMPILER
  class LanguageRecognitionError < StandardError
    attr_reader :count_dict
    def initialize(message, count_list)
      super(message)
      @count_dict = {
        "Python Count: " => count_list[0],
        "Java Count: " => count_list[1],
        "JavaScript Count: " => count_list[2]
      }
    end
  end
end
