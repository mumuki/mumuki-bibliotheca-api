source 'https://rubygems.org'

gemspec

ruby '~> 2.3'

gem 'puma', '~> 3.7'

group :test do
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  gem 'rake', '~> 12.3.0'
  gem 'faker', '~> 1.5'
  gem 'capybara', '~> 2.3.0'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rack-test'
end

group :development do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-byebug' unless Gem.win_platform?
  gem 'pry-stack_explorer'
  gem 'binding_of_caller'
  gem 'web-console'
end

gem 'mumuki-domain', github: 'mumuki/mumuki-domain', ref: 'dbe159e37afe40cc408bc728b271ab6a4973003e'
