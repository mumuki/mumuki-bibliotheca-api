require 'sinatra/cookies'

use Rack::Session::Cookie,
    key: '_mumuki_bibliotheca_session',
    domain: '.localmumuki.io',
    httponly: false
