require_relative './lib/bibliotheca'

raise 'Missing bot username' unless Mumukit::Service::Env.bot_username
raise 'Missing bot email' unless Mumukit::Service::Env.bot_email

require_relative './app/routes'

run Sinatra::Application
