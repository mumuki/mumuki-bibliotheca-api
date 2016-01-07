module Bibliotheca::IO
  module ImportMessages
    def no_description(name)
      messages << "Description does not exist for #{name}"
    end

    def no_meta(name)
      messages << "Meta does not exist for #{name}"
    end
  end

  class Log
    attr_accessor :messages

    include Bibliotheca::IO::ImportMessages

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