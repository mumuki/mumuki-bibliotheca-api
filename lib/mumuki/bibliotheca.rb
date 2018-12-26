module Mumuki
  module Bibliotheca
  end
end

require 'mumuki/domain'
require 'mumukit/login'
require 'mumukit/nuntius'
require 'mumukit/platform'

module Mumukit::Nuntius
  def self.notify_content_change_event!(content_kind, slug)
    notify_event! content_change_event_name(content_kind), slug: slug.to_s
  end

  def self.content_change_event_name(content_kind)
    "#{content_kind.to_s.camelize}Changed"
  end
end

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
