module Bibliotheca::Collection::Guides
  extend Mumukit::Service::Collection
  extend Bibliotheca::Collection::WithSlug

  private

  def self.mongo_collection_name
    :guides
  end

  def self.mongo_database
    Bibliotheca::Database
  end

  def self.wrap(it)
    Bibliotheca::Guide.new(it)
  end

  def self.wrap_array(it)
    Bibliotheca::Collection::GuideArray.new(it)
  end
end

