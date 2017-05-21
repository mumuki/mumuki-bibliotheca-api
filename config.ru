## Development defaults
if ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  ENV['MUMUKI_BOT_USERNAME'] ||= ENV['USER']
  ENV['MUMUKI_BOT_EMAIL'] ||= "#{ENV['MUMUKI_BOT_USERNAME']}@localhost"
  ENV['SECRET_KEY_BASE'] ||= 'aReallyStrongKeyForDevelopment'
end

## Require code
require_relative './lib/bibliotheca'
require_relative './app/routes'

## Essential parameters validation
raise 'Missing bot username' unless Mumukit::Service::Env.bot_username
raise 'Missing bot email' unless Mumukit::Service::Env.bot_email
raise 'Missing secret key' unless Mumukit::Login.config.mucookie_secret_key

## Start server
run Sinatra::Application