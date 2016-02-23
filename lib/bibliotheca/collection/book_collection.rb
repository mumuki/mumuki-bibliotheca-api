module Bibliotheca::Collection::Books
  extend Mumukit::Service::Collection

  private

  def self.mongo_collection_name
    :guides
  end

  def self.mongo_collection_database
    Mumukit::Service::Database
  end

  def self.wrap(it)
    Bibliotheca::Book.new(it)
  end

  def self.wrap_array(it)
    Bibliotheca::BookArray.new(it)
  end
end

