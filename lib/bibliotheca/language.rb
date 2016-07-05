module Bibliotheca
  class Language
    attr_accessor :name, :extension, :test_extension, :ace_mode, :devicon, :test_runner_url

    def initialize(args={})
      @name = args[:name]
      @extension = args[:extension]
      @test_extension = args[:test_extension] || @extension
      @ace_mode = args[:ace_mode]
      @devicon = args[:devicon]
      @test_runner_url = args[:url]
    end

    def as_json(options={})
      if options[:full_language]
        {name: name,
         extension: extension,
         test_extension: test_extension,
         ace_mode: ace_mode,
         devicon: devicon,
         test_runner_url: test_runner_url}
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
                     devicon: 'haskell',
                     url: 'http://mumuki-hspec-server.herokuapp.com'),
        Language.new(name: 'java',
                     extension: 'java',
                     ace_mode: 'java',
                     devicon: 'java',
                     url: 'http://runners.mumuki.io:8004'),
        Language.new(name: 'wollok',
                     extension: 'wlk',
                     ace_mode: 'wollok',
                     devicon: 'webplatform',
                     url: 'http://runners2.mumuki.io:8003'),
        Language.new(name: 'c',
                     extension: 'c',
                     ace_mode: 'c_cpp',
                     url: 'http://runners.mumuki.io:8002'),
        Language.new(name: 'c++',
                     extension: 'cpp',
                     ace_mode: 'c_cpp',
                     url: 'http://runners.mumuki.io:8003'),
        Language.new(name: 'prolog',
                     extension: 'pl',
                     ace_mode: 'prolog',
                     devicon: 'prolog',
                     url: 'http://mumuki-plunit-server.herokuapp.com'),
        Language.new(name: 'ruby',
                     extension: 'rb',
                     ace_mode: 'ruby',
                     devicon: 'ruby_rough',
                     url: 'http://runners.mumuki.io:8001'),
        Language.new(name: 'gobstones',
                     extension: 'gbs',
                     test_extension: 'yml',
                     ace_mode: 'gobstones',
                     devicon: 'celluloid',
                     url: 'http://runners2.mumuki.io:8001'),
        Language.new(name: 'javascript',
                     extension: 'js',
                     ace_mode: 'javascript',
                     devicon: 'javascript_badge',
                     url: 'http://runners1.mumuki.io:8004/info'),
        Language.new(name: 'python',
                     extension: 'py',
                     ace_mode: 'python',
                     devicon: 'python',
                     url: 'http://python.runners.mumuki.io'),
        Language.new(name: 'text',
                     extension: 'txt',
                     test_extension: 'yml',
                     devicon: 'code',
                     url: 'http://runners2.mumuki.io:8002')]

  end
end
