require 'mumukit/auth'

Mumukit::Auth.configure do |c|
  c.client_id = ENV['MUMUKI_BIBLIOTHECA_CLIENT_ID']
  c.client_secret = ENV['MUMUKI_BIBLIOTHECA_CLIENT_SECRET']
end

require './app/routes'

run Sinatra::Application
