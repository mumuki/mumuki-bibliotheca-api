module Mumuki
  module Bibliotheca
    class Engine < ::Rails::Engine
      endpoint BibliothecaApi
      config.generators.api_only = true
    end
  end
end
