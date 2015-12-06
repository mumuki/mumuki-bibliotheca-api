module GitIo
  class Language
    attr_accessor :name, :extension, :test_extension, :ace_mode, :devicon

    def initialize(args={})
      @name = args[:name]
      @extension = args[:extension]
      @test_extension = args[:test_extension] || @extension
      @ace_mode = args[:ace_mode]
      @devicon = args[:devicon]
    end

    def as_json(options={})
      if options[:full_language]
        {name: name,
         extension: extension,
         test_extension: test_extension,
         ace_mode: ace_mode,
         devicon: devicon}
      else
        name
      end
    end

    def self.find_by_name(name)
      name = name.to_s.downcase
      LANGUAGES.find { |l| l.name == name } || (raise "Unsupported language `#{name}`")
    end

    LANGUAGES = [
        Language.new(name: 'haskell',
                     extension: 'hs',
                     ace_mode: 'haskell',
                     devicon: 'haskell'),
        Language.new(name: 'java',
                     extension: 'java',
                     ace_mode: 'java',
                     devicon: 'java'),
        Language.new(name: 'wollok',
                     extension: 'wlk',
                     ace_mode: 'wollok'),
        Language.new(name: 'c',
                     extension: 'c',
                     ace_mode: 'c'),
        Language.new(name: 'prolog',
                     extension: 'pl',
                     ace_mode: 'prolog',
                     devicon: 'prolog'),
        Language.new(name: 'ruby',
                     extension: 'rb',
                     ace_mode: 'ruby',
                     ruby_rough: 'ruby_rough'),
        Language.new(name: 'gobstones',
                     extension: 'gbs',
                     test_extension: 'yml',
                     ace_mode: 'gobstones'),
        Language.new(name: 'javascript',
                     extension: 'js',
                     ace_mode: 'javascript',
                     devicon: 'javascript_badge')]
  end
end