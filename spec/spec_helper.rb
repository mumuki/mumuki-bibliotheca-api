require 'factory_girl'

require 'rack/test'

require_relative '../lib/content_server'
require_relative './factories/language_factory'

ENV['RACK_ENV'] = 'test'

Mongo::Logger.logger.level = ::Logger::INFO

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
end

RSpec::Matchers.define :json_eq do |expected_json_hash|
  match do |actual_json|
    expected_json_hash.with_indifferent_access == ActiveSupport::JSON.decode(actual_json)
  end
end
