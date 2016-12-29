require_relative './lib/bibliotheca'

raise 'Missing auth0 client_id' unless Mumukit::Service::Env.auth0_client_id
raise 'Missing auth0 client_secret' unless Mumukit::Service::Env.auth0_client_secret

raise 'Missing bot username' unless Mumukit::Service::Env.bot_username
raise 'Missing bot email' unless Mumukit::Service::Env.bot_email

require_relative './app/routes'

run Sinatra::Application
