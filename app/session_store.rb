require 'sinatra/cookies'

use Rack::Session::Cookie,
<<<<<<< Updated upstream
    key: '_mumuki_bibliotheca_session',
    domain: ENV['MUMUKI_COOKIES_DOMAIN']
=======
    key: '_mumuki_bibliotheca_session', httponly: false
>>>>>>> Stashed changes
