module GitIo
  class Language
    attr_accessor :name, :extension, :test_extension

    def initialize(args={})
      @name =args[:name]
      @extension = args[:extension]
      @test_extension = args[:test_extension]
    end

    def self.find_by_name(name)
      self.new(name: name, extension: 'hs', test_extension: 'hs') #fixme
    end
  end
end