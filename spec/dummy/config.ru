## Development defaults
if ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  ENV['MUMUKI_BOT_USERNAME'] ||= ENV['USER']
  ENV['MUMUKI_BOT_EMAIL'] ||= "#{ENV['MUMUKI_BOT_USERNAME']}@localhost"
  ENV['SECRET_KEY_BASE'] ||= 'aReallyStrongKeyForDevelopment'
end

## Start server
require_relative 'config/environment'

## Essential parameters validation
raise 'Missing bot username' unless Mumukit::Service::Env.bot_username
raise 'Missing bot email' unless Mumukit::Service::Env.bot_email
raise 'Missing secret key' unless Mumukit::Login.config.mucookie_secret_key

## Start Nuntius
Mumukit::Nuntius.establish_connection

run Rails.application
