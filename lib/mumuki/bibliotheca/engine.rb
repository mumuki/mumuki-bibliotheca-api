module Mumuki
  module Bibliotheca
    class Engine < ::Rails::Engine
      endpoint Sinatra::Application.new
      config.generators.api_only = true
    end
  end
end
