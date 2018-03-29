module Bibliotheca::Collection
  module Organizations
    extend Mumukit::Service::Collection
    extend Bibliotheca::Collection::WithSlug

    def self.base
      find_by!(name: 'base')
    end

    def self.find_by_name!(name)
      find_by! name: name
    end

    def self.import_from_json!(json)
      json = Mumukit::Platform::Organization::Helpers.slice_platform_json json
      upsert_by! :name, Bibliotheca::Organization.new(json) if json[:name] == 'base'
    end

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
