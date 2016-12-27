require 'mumukit/core'
require 'mumukit/service'
require 'mumukit/bridge'

module Bibliotheca
  class SchemaDocument < Mumukit::Service::Document
    delegate :defaults, to: :schema
    def initialize(json)
      super(json)
      @raw = schema.slice(@raw)
    end
  end
end

require_relative './bibliotheca/database'
require_relative './bibliotheca/bot'
require_relative './bibliotheca/schema'
require_relative './bibliotheca/exercise'
require_relative './bibliotheca/guide'
require_relative './bibliotheca/book'
require_relative './bibliotheca/topic'
require_relative './bibliotheca/language'
require_relative './bibliotheca/ordering'
require_relative './bibliotheca/io'
require_relative './bibliotheca/collection'
require_relative './bibliotheca/event'

