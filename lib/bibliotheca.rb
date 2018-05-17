require 'mumukit/core'
require 'mumukit/auth'
require 'mumukit/service'
require 'mumukit/bridge'
require 'mumukit/nuntius'
require 'mumukit/login'
require 'mumukit/platform'
require 'mumukit/inspection'

class Mumukit::Auth::Slug
  def rebase(new_organizaton)
    Mumukit::Auth::Slug.new(new_organizaton, repository)
  end
end

module Bibliotheca
  class SchemaDocument < Mumukit::Service::Document
    delegate :defaults, to: :schema

    def initialize(json)
      super(json)
      @raw = schema.slice(@raw)
      self.slug = @raw[:slug].downcase if @raw[:slug]
    end

    def rebase!(organization)
      self.slug = self.slug.to_mumukit_slug.rebase(organization).to_s
    end

    def copy
      dup.tap { |it| it.id = nil }
    end

    def rebased_copy(organization)
      copy.tap { |it| it.rebase! organization }
    end
  end
end

class Hash
  def indifferent_delete(key)
    [delete(key.to_sym), delete(key.to_s)].compact.first
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
  config.user_class = Bibliotheca::Collection::Users
  config.organization_class = Bibliotheca::Collection::Organizations
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
