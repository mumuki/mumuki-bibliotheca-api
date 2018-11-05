require "mumuki/bibliotheca/engine"

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

require_relative './bibliotheca/sinatra'

module Mumuki::Bibliotheca
  API_SYNC_INFLATORS = [Mumukit::Sync::Inflator::SingleChoice.new, Mumukit::Sync::Inflator::MultipleChoice.new]
  HISTORY_SYNC_INFLATORS = []

  def self.history_syncer(bot, username = nil)
    Mumukit::Sync::Syncer.new(
      ## FIXME remove this hardcoded URL. Get it from Mumukit::Platform.application
      Mumukit::Sync::Store::Github.new(bot, username, "http://bibliotheca-api.mumuki.io/guides/import/"),
      HISTORY_SYNC_INFLATORS)
  end

  def self.api_syncer(json)
    Mumukit::Sync::Syncer.new(ApiSource.new(json), API_SYNC_INFLATORS)
  end

  class ApiSource < Mumukit::Sync::Store::Json
    def pre_transform(key, json)
      Mumukit::Sync.constantize(key).whitelist_attributes(json, relations: true)
    end

    def post_transform(key, json)
      if key == :guide
        guide = json.dup
        wrap_language! guide
        guide[:exercises].each { |exercise| wrap_language! exercise }
        guide
      else
        json
      end
    end

    def wrap_language!(hash)
      hash[:language] = { name: hash[:language] } if hash[:language]
    end
  end
end
