require 'mumukit/auth'


raise 'Missing auth0 client_id' unless Bibliotheca::Env.auth0_client_id
raise 'Missing auth0 client_secret' unless Bibliotheca::Env.auth0_client_secret

raise 'Missing bot username' unless Bibliotheca::Env.bot_username
raise 'Missing bot email' unless Bibliotheca::Env.bot_email

Mumukit::Auth.configure do |c|
  c.client_id = Bibliotheca::Env.auth0_client_id
  c.client_secret = Bibliotheca::Env.auth0_client_secret
end

require './app/routes'

run Sinatra::Application
