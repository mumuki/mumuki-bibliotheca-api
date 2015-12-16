module Bibliotheca::IO
  class Log
    attr_accessor :messages

    def initialize
      @messages = []
    end

    def with_error_logging
      yield
    rescue => e
      messages << e.inspect
      raise e
    end

    def to_s
      @messages.join(', ')
    end
  end
end