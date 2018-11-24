module Mumuki
  module Bibliotheca
  end
end

require 'mumuki/domain'
require 'mumukit/login'
require 'mumukit/nuntius'
require 'mumukit/platform'

Mumukit::Nuntius.configure do |c|
  c.app_name = 'bibliotheca'
end

Mumukit::Platform.configure do |config|
  config.application = Mumukit::Platform.bibliotheca_api
  config.web_framework = Mumukit::Platform::WebFramework::Sinatra
end

require_relative './bibliotheca/syncer'
require_relative './bibliotheca/sinatra'
require_relative './bibliotheca/engine'
