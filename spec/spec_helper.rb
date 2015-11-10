require 'factory_girl'

require_relative '../lib/content_server'

require_relative './factories/language_factory'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.after(:each) do
    Database.client[:guides].drop
  end
end
