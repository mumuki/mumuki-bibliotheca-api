require_relative './lib/bibliotheca'

if ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  ENV['MUMUKI_BOT_USERNAME'] ||= ENV['USER']
  ENV['MUMUKI_BOT_EMAIL'] ||= "#{ENV['MUMUKI_BOT_USERNAME']}@localhost"
end

raise 'Missing bot username' unless Mumukit::Service::Env.bot_username
raise 'Missing bot email' unless Mumukit::Service::Env.bot_email

require_relative './app/routes'

run Sinatra::Application
