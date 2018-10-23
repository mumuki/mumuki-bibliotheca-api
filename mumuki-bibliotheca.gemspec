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
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"

  s.add_dependency 'sinatra-contrib'
  s.add_dependency 'sinatra-cross_origin', '~> 0.3.1'

  s.add_dependency 'mumukit-auth', '~> 7.4'
  s.add_dependency 'mumukit-sync', '~> 0.0'
  s.add_dependency 'mumukit-platform', '~> 2.7'
  s.add_dependency 'mumukit-login', '~> 6.1'
  s.add_dependency 'mumukit-content-type', '~> 1.3'
  s.add_dependency 'mumukit-core', '~> 1.3'
  s.add_dependency 'mumukit-bridge', '~> 3.7'
  s.add_dependency 'mumukit-nuntius', '~> 6.1'
  s.add_dependency 'mumukit-inspection', '~> 3.5'
  s.add_dependency 'mumukit-assistant', '~> 0.1'
  s.add_dependency 'mumukit-randomizer', '~> 1.1'
  s.add_dependency 'mumuki-domain', '~> 5.7'

  s.add_dependency 'rack', '~> 2.0'
  s.add_development_dependency 'pg', '~> 0.18.0'
end
