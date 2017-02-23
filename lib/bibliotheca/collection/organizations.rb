module Bibliotheca::Collection
  module Organizations
    extend Mumukit::Service::Collection
    extend Bibliotheca::Collection::WithSlug

    def self.base
      find_by!(name: 'base')
    end

    def self.import_from_json!(organization_json)
      upsert_by! :name, Bibliotheca::Organization.new(organization_json) if organization_json[:name] == 'base'
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
