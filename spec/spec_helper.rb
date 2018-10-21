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

Mongo::Logger.logger.level = ::Logger::INFO

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
    config.include Rack::Test::Methods
    config.include FactoryBot::Syntax::Methods
    config.infer_spec_type_from_file_location!
end

RSpec::Matchers.define :json_eq do |expected_json_hash|
  match do |actual_json|
    expected_json_hash.with_indifferent_access == ActiveSupport::JSON.decode(actual_json)
  end
end

RSpec::Matchers.define :json_like do |expected, options={}|

  match do |actual|
    actual.as_json.with_indifferent_access.as_json(options) == expected.as_json.with_indifferent_access.as_json(options)
  end

  failure_message_for_should do |actual|
    <<-EOS
    expected: #{expected.as_json.with_indifferent_access.as_json(options)} (#{expected.class})
         got: #{actual.as_json.with_indifferent_access.as_json(options)} (#{actual.class})
    EOS
  end

  failure_message_for_should_not do |actual|
    <<-EOS
    expected: value != #{expected.as_json.with_indifferent_access.as_json(options)} (#{expected.class})
         got:          #{actual.as_json.with_indifferent_access.as_json(options)} (#{actual.class})
    EOS
  end
end

ENV['MUMUKI_BOT_USERNAME'] = 'mumukibot'
ENV['MUMUKI_BOT_EMAIL'] = 'bot@mumuki.org'
ENV['MUMUKI_BOT_API_TOKEN'] = 'fake_token'

require 'base64'
Mumukit::Auth.configure do |c|
  c.clients.default = {id: 'test-client', secret: 'thisIsATestSecret'}
end

def build_auth_header(permissions, uid='bot@mumuki.org')
  User.new(uid: uid, permissions: permissions).save!
  Mumukit::Auth::Token.encode uid, {}
end

SimpleCov.start
