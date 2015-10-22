module GitIo::Operation
  class ImportLog
    attr_accessor :messages

    def initialize
      @messages = []
    end

    def no_description(name)
      @messages << "Description does not exist for #{name}"
    end

    def no_meta(name)
      @messages << "Meta does not exist for #{name}"
    end

    def to_s
      @messages.join(', ')
    end
  end
end