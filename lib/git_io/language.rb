module GitIo
  class Language
    attr_accessor :name, :extension

    def initialize(name, extension)
      @name = name
      @extension = extension
    end

    def self.find_by_name(name)
      self.new(name, 'hs') #fixme
    end
  end
end