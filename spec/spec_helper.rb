require 'factory_girl'

require_relative '../lib/git_io'
require_relative '../lib/guide_collection'
require_relative '../lib/database'

require_relative './factories/language_factory'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.after(:each) do
    Database.client.database.drop
  end
end
