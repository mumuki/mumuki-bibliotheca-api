require 'factory_girl'

require_relative '../lib/content_server'

require_relative './factories/language_factory'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

RSpec::Matchers.define :json_eq do |expected_json_hash|
  match do |actual_json|
    expected_json_hash.with_indifferent_access == ActiveSupport::JSON.decode(actual_json)
  end
end
