require 'mumukit/core'
require 'mumukit/auth'
require 'mumukit/service'
require 'mumukit/bridge'
require 'mumukit/nuntius'
require 'mumukit/login'
require 'mumukit/platform'

module Bibliotheca
  class SchemaDocument < Mumukit::Service::Document
    delegate :defaults, to: :schema

    def initialize(json)
      super(json)
      @raw = schema.slice(@raw)
    end
  end
end


require_relative './bibliotheca/database'
require_relative './bibliotheca/bot'
require_relative './bibliotheca/schema'
require_relative './bibliotheca/organization'
require_relative './bibliotheca/exercise'
require_relative './bibliotheca/guide'
require_relative './bibliotheca/book'
require_relative './bibliotheca/topic'
require_relative './bibliotheca/user'
require_relative './bibliotheca/language'
require_relative './bibliotheca/ordering'
require_relative './bibliotheca/io'
require_relative './bibliotheca/collection'

module Mumukit::Nuntius
  def self.notify_content_change_event!(content_class, slug)
    notify_event! content_change_event_name(content_class), slug: slug.to_s
  end

  def self.content_change_event_name(content_class)
    "#{content_class.name.demodulize}Changed"
  end
end

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
  config.user_class = Bibliotheca::Collection::Users
  config.framework = Mumukit::Login::Framework::Sinatra
end

class Mumukit::Auth::Slug
  def bibliotheca_guide_web_hook_url
    "http://bibliotheca-api.mumuki.io/guides/import/#{to_s}"
  end
end
