module Bibliotheca::Collection::Guides
  extend Mumukit::Service::Collection

  def self.allowed(permissions)
    project { |it| permissions.allows? it.slug }
  end

  def self.find_by_slug(slug)
    find_by(slug: slug)
  end

  def self.upsert_by_slug(slug, guide)
    guide.validate!
    guide.consistent_slug! slug

    with_id(id_for_slug(slug) || new_id) do |id|
      mongo_collection.update_one({slug: slug}, guide.raw.merge(id), {upsert: true})
    end
  end

  private

  def self.id_for_slug(slug)
    mongo_collection.find({slug: slug}).projection(id: 1).first.try { |it| it[:id] }
  end

  def self.mongo_collection_name
    :guides
  end

  def self.mongo_database
    Bibliotheca::Collection::Database
  end

  def self.wrap(it)
    Bibliotheca::Guide.new(it)
  end

  def self.wrap_array(it)
    Bibliotheca::Collection::GuideArray.new(it)
  end
end

