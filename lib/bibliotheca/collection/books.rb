module Bibliotheca::Collection
  module Books
    extend Mumukit::Service::Collection
    extend Bibliotheca::Collection::WithSlug

    private

    def self.mongo_collection_name
      :books
    end

    def self.mongo_database
      Bibliotheca::Database
    end

    def self.wrap(it)
      Bibliotheca::Book.new(it)
    end

    def self.wrap_array(it)
      Bibliotheca::Collection::BookArray.new(it)
    end
  end

  class BookArray < Mumukit::Service::DocumentArray
    def options
      {only: [:id, :name, :slug, :chapters]}
    end

    def key
      :books
    end
  end
end
