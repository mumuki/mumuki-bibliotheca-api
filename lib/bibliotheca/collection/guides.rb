module Bibliotheca::Collection::Guides

  class << self
    def all
      GuideArray.new _all
    end

    def allowed(permissions)
      GuideArray.new _all.select { |it| permissions.allows? it.slug }
    end

    def count
      guides.find.count
    end

    def exists?(id)
      guides.find({id: id}).count > 0
    end

    def find(id)
      find_by(id: id)
    end

    def find_by(args)
      first = guides.find(args).projection(_id: 0).first
      raise Bibliotheca::Collection::GuideNotFoundError.new("guide #{args.to_json} not found") unless first
      Bibliotheca::Guide.new first.to_h
    end

    def find_by_slug(slug)
      find_by(slug: slug)
    end

    def delete(id)
      guides.delete_one(id: id)
    end

    def insert(guide)
      guide.validate!

      with_id new_id do |id|
        guides.insert_one guide.raw.merge(id)
      end
    end

    def upsert_by_slug(slug, guide)
      guide.validate!
      guide.consistent_slug! slug

      with_id(id_for_slug(slug) || new_id) do |id|
        guides.update_one({slug: slug}, guide.raw.merge(id), {upsert: true})
      end
    end

    private

    def _all
      guides.find.projection(_id: 0).map { |it| Bibliotheca::Guide.new(it) }
    end

    def id_for_slug(slug)
      guides.find({slug: slug}).projection(id: 1).first.try { |it| it[:id] }
    end

    def new_id
      Bibliotheca::IdGenerator.next
    end

    def guides
      Bibliotheca::Collection::Database.client[:guides]
    end

    def with_id(id)
      id_object = {id: id}
      yield id_object
      id_object
    end
  end
end

require_relative './guide_collection/guide_array'
