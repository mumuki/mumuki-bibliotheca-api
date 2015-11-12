module GuideCollection

  class << self
    def count
      guides.find.count
    end

    def insert(guide_json)
      with_id new_id do |id|
        guides.insert_one guide_json.merge(id)
      end
    end

    def find(id)
      find_by(id: id)
    end

    def find_by(args)
      first = guides.find(args).projection(_id: 0).first
      raise "guide #{args.to_json} not found" unless first
      GuideDocument.new first.to_h
    end

    def find_by_slug(organization_or_slug, repository=nil)
      slug = repository ? GitIo::Repo.new(organization_or_slug, repository).full_name : organization_or_slug
      find_by(github_repository: slug)
    end

    def update(id, guide_json)
      consistent! 'id', id, guide_json
      with_id id do |_id|
        guides.update_one _id, guide_json.merge(_id)
      end
    end

    def upsert_by_slug(slug, guide_json)
      consistent! 'slug', slug, guide_json
      with_id(id_for_slug(slug) || new_id) do |id|
        guides.update_one({github_repository: slug}, guide_json.as_json.merge(id), {upsert: true})
      end
    end

    private

    def id_for_slug(slug)
      guides.find({github_repository: slug}).projection(id: 1).first.try { |it| it[:id] }
    end

    def new_id
      IdGenerator.next
    end

    def guides
      Database.client[:guides]
    end

    def consistent!(field, original_value, guide_json)
      guide_value = guide_json[field]
      raise "inconsistent #{field} #{original_value} and #{guide_value}" if guide_value.present? && guide_value != original_value
    end

    def with_id(id)
      id_object = {id: id}
      yield id_object
      id_object
    end

  end
end

class GuideDocument

  def initialize(document)
    @document = document
  end

  def method_missing(name, *args, &block)
    wrapped.send name, *args, &block
  end

  def as_json(options={})
    wrapped.as_json(options)
  end

  def raw
    @document
  end

  private

  def wrapped
    @wrapped ||= GitIo::Guide.new(@document)
  end

end


