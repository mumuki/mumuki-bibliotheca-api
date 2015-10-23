module GitIo
  class Language
    attr_accessor :name, :extension, :test_extension

    def initialize(args={})
      @name =args[:name]
      @extension = args[:extension]
      @test_extension = args[:test_extension] || @extension
    end

    def self.find_by_name(name)
      name = name.to_s.downcase
      LANGUAGES.find { |l| l.name == name } || (raise "Unsupported language #{name}")
    end

    LANGUAGES = [
        Language.new(name: 'haskell', extension: 'hs'),
        Language.new(name: 'java', extension: 'java'),
        Language.new(name: 'wollok', extension: 'wlk'),
        Language.new(name: 'c', extension: 'c'),
        Language.new(name: 'prolog', extension: 'pl'),
        Language.new(name: 'ruby', extension: 'rb'),
        Language.new(name: 'gobstones', extension: 'gbs', test_extension: 'yml'),
        Language.new(name: 'javascript', extension: 'js')]

  end
end