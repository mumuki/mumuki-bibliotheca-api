require "mumuki/bibliotheca/engine"

module Mumuki
  module Bibliotheca
  end
end

require 'mumukit/core'
require 'mumukit/auth'
require 'mumukit/service'
require 'mumukit/bridge'
require 'mumukit/nuntius'
require 'mumukit/login'
require 'mumukit/platform'
require 'mumukit/inspection'
require 'mumukit/assistant'
require 'mumukit/randomizer'

require 'mumuki/domain'

Mumukit::Nuntius.configure do |c|
  c.app_name = 'bibliotheca'
end

Mumukit::Auth.configure do |c|

end

Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform.bibliotheca_api
  config.web_framework = Mumukit::Platform::WebFramework::Sinatra
end

Mumukit::Login.configure do |config|
end

class Mumukit::Auth::Slug
  def bibliotheca_guide_web_hook_url
    "http://bibliotheca-api.mumuki.io/guides/import/#{to_s}"
  end
end

require_relative './bibliotheca/sinatra'
