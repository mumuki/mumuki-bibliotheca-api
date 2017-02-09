require 'sinatra/cookies'

use Rack::Session::Cookie,
    key: '_mumuki_bibliotheca_session',
    domain: ENV['MUMUKI_COOKIES_DOMAIN'],
    httponly: false
