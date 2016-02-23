module Bibliotheca::Collection::WithSlug
  def allowed(permissions)
    project { |it| permissions.allows? it.slug }
  end

  def find_by_slug(slug)
    find_by(slug: slug)
  end

  def upsert_by_slug(slug, guide)
    guide.validate!
    guide.consistent_slug! slug

    with_id(id_for_slug(slug) || new_id) do |id|
      mongo_collection.update_one({slug: slug}, guide.raw.merge(id), {upsert: true})
    end
  end

  private

  def id_for_slug(slug)
    mongo_collection.find({slug: slug}).projection(id: 1).first.try { |it| it[:id] }
  end
end