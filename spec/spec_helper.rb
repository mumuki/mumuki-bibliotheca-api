require 'factory_girl'

require_relative '../lib/git_io'
require_relative './factories/language_factory'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
