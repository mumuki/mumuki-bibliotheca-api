module Mumuki
  module Bibliotheca
    class Engine < ::Rails::Engine
      endpoint Mumuki::Bibliotheca::App
      config.generators.api_only = true
    end
  end
end
