ENV['RACK_ENV'] = 'test'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'factory_girl'

require 'rack/test'

require 'mumukit/auth'
require 'mumukit/content_type'

require_relative '../lib/bibliotheca'
require_relative './factories/language_factory'
require_relative './factories/topic_factory'
require_relative './factories/book_factory'
require_relative './factories/guide_factory'
require_relative './factories/exercise_factory'

Mongo::Logger.logger.level = ::Logger::INFO

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
  config.before { Bibliotheca::Database.clean! }
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

def build_auth_header(permissions, email='bot@mumuki.org')
  Bibliotheca::Collection::Users.upsert_permissions! email, permissions
  Mumukit::Auth::Token.encode email, {}
end
