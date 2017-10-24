module Bibliotheca::Collection
  module Languages
    extend Mumukit::Service::Collection

    private

    def self.mongo_collection_name
      :languages
    end

    def self.mongo_database
      Bibliotheca::Database
    end

    def self.import!(url)
      import_from_json! Mumukit::Bridge::Runner.new(url).importable_info
    end

    def self.import_from_json!(language_json)
      upsert_by! :name, Bibliotheca::Language.new(language_json)

    end

    def self.wrap(it)
      Bibliotheca::Language.new(it)
    end

    def self.wrap_array(it)
      Bibliotheca::Collection::LanguageArray.new(it)
    end
  end

  class LanguageArray < Mumukit::Service::DocumentArray

    def options
      {except: [:id],
       full_language: true}
    end

    def key
      :languages
    end
  end
end
