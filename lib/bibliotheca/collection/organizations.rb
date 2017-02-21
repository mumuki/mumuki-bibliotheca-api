module Bibliotheca::Collection
  module Organizations
    extend Mumukit::Service::Collection
    extend Bibliotheca::Collection::WithSlug

    private

    def self.mongo_collection_name
      :organizations
    end

    def self.mongo_database
      Bibliotheca::Database
    end

    def self.wrap(it)
      Bibliotheca::Organization.new(it)
    end
  end
end
