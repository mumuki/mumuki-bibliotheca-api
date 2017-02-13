require 'omniauth'

use OmniAuth::Builder do
  Mumukit::Login.configure_omniauth! self
end
