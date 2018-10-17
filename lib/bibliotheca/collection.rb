module Bibliotheca::Collection
  def self.insert_hash!(type, hash)
    base_class_name = type.classify
    resourceClass = "Bibliotheca::#{base_class_name}".constantize
    collectionClass = "Bibliotheca::Collection::#{base_class_name.pluralize}".constantize

    collectionClass.insert! resourceClass.new(hash)
  end
end


require_relative './collection/exercise_not_found_error'
require_relative './collection/guide_already_exists'
require_relative './collection/with_slug'
require_relative './collection/guides'
require_relative './collection/topics'
require_relative './collection/books'
