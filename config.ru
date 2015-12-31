require 'mumukit/auth'

Mumukit::Auth.configure do |c|
  c.client_id = ENV['MUMUKI_BIBLIOTHECA_CLIENT_ID']
  c.client_secret = ENV['MUMUKI_BIBLIOTHECA_CLIENT_SECRET']
end

raise 'Missing auth0 client_id' unless Mumukit::Auth.config.client_id
raise 'Missing auth0 client_secret' unless Mumukit::Auth.config.client_secret

require './app/routes'

run Sinatra::Application
