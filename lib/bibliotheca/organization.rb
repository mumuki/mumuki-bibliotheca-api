module Bibliotheca
  class Organization < Bibliotheca::SchemaDocument
    include Mumukit::Platform::Organization::Helpers

    def schema
      Bibliotheca::Schema::Organization
    end
  end
end
