module Mumuki
  module Bibliotheca
    class Engine < ::Rails::Engine
      endpoint BibliothecaApi.new
      config.generators.api_only = true
    end
  end
end
