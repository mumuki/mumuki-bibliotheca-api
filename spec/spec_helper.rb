ENV['RACK_ENV'] = 'test'
ENV['RAILS_ENV'] = 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'codeclimate-test-reporter'
require 'mumukit/core/rspec'
require 'factory_bot_rails'

ActiveRecord::Migration.maintain_test_schema!

require 'rack/test'
require 'mumukit/auth'
require 'mumukit/content_type'

require_relative '../lib/mumuki/bibliotheca'
require_relative './factories/language_factory'
require_relative './factories/topic_factory'
require_relative './factories/book_factory'
require_relative './factories/guide_factory'
require_relative './factories/exercise_factory'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.full_backtrace = true if ENV['RSPEC_FULL_BACKTRACE']
end

require 'base64'
Mumukit::Auth.configure do |c|
  c.clients.default = {id: 'test-client', secret: 'thisIsATestSecret'}
end

def build_auth_header(permissions, uid='bot@mumuki.org')
  User.new(uid: uid, permissions: permissions).save!
  Mumukit::Auth::Token.encode uid, {}
end

def import_from_api!(kind, json)
  Mumuki::Bibliotheca.api_syncer(json).locate_and_import! kind, json.with_indifferent_access[:slug]
end

SimpleCov.start
