module Bibliotheca::Collection
  module Topics
    extend Mumukit::Service::Collection
    extend Bibliotheca::Collection::WithSlug

    private

    def self.mongo_collection_name
      :topics
    end

    def self.mongo_database
      Bibliotheca::Database
    end

    def self.wrap(it)
      Bibliotheca::Topic.new(it)
    end

    def self.wrap_array(it)
      Bibliotheca::Collection::TopicsArray.new(it)
    end
  end

  class TopicsArray < Mumukit::Service::DocumentArray
    def options
      {only: [:id, :name, :slug]}
    end

    def key
      :topics
    end
  end
end
