require_relative './lib/bibliotheca'

ENV['MUMUKI_BOT_USERNAME'] ||= ENV['USER']
ENV['MUMUKI_BOT_EMAIL'] ||= "#{ENV['MUMUKI_BOT_USERNAME']}@localhost"

raise 'Missing bot username' unless Mumukit::Service::Env.bot_username
raise 'Missing bot email' unless Mumukit::Service::Env.bot_email

require_relative './app/routes'

run Sinatra::Application
