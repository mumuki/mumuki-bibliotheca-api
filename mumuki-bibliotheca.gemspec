$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mumuki/bibliotheca/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mumuki-bibliotheca"
  s.version     = Mumuki::Bibliotheca::VERSION
  s.authors     = ["Franco Bulgarelli"]
  s.email       = ["franco@mumuki.org"]
  s.homepage    = "https://mumuki.org"
  s.summary     = "API for editing content on mumuki"
  s.description = "API for editing content on mumuki"
  s.license     = "AGPL-3.0"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"

  s.add_dependency 'sinatra', '~> 2.0'
  s.add_dependency 'sinatra-contrib', '~> 2.0'
  s.add_dependency 'sinatra-cross_origin', '~> 0.3.1'

  s.add_dependency 'mumuki-domain', '~> 9.23.0'
  s.add_dependency 'mumukit-login', '~> 7.0'
  s.add_dependency 'mumukit-nuntius', '~> 6.1'
  s.add_dependency 'mumukit-sync', '~> 1.0'
  s.add_dependency 'sprockets', '~> 3.7'

  s.add_dependency 'rack', '~> 2.0'
  s.add_development_dependency 'pg', '~> 0.18.0'
  s.add_development_dependency 'bundler', '~> 2.0'
end
