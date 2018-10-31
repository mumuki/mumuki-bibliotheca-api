require_relative 'boot'

require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)
require "mumuki/bibliotheca"

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = true
    Mumuki::Domain::Engine.paths['db/migrate'].expanded.each do |expanded_path|
      config.paths['db/migrate'] << expanded_path
    end
  end
end

