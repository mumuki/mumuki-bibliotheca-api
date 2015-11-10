module GuideCollection

  class << self
    def count
      guides.find.count
    end

    def insert(guide_json)
      id = {id: new_id}
      guides.insert_one guide_json.merge(id)
      id
    end

    def find(id)
      find_by(id: id)
    end

    def find_by(args)
      GuideDocument.new guides.find(args).projection(_id: 0).first.to_h
    end

    def find_by_slug(organization, repository)
      find_by(github_repository: GitIo::Repo.new(organization, repository).full_name)
    end

    def update(id, guide_json)
      id = {id: id}
      guides.update_one id, guide_json
    end

    def consistent!(id, guide_json)
      guide_id = guide_json['id']
      raise "inconsistent ids #{id} and #{guide_id}" if guide_id.present? && guide_id != id
    end

    private

    def new_id
      IdGenerator.next
    end

    def guides
      Database.client[:guides]
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


