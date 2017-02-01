use Rack::Session::Cookie,
    key: '_mumuki_session',
    domain: '.localmumuki.io'

use OmniAuth::Builder do
  Mumukit::Login.configure_omniauth! self
end
