module GitIo::Operation
  class Import < GitIo::Operation::Operation
    attr_accessor :repo

    def initialize(bot, repo)
      super(bot)
      @repo = repo
    end

    def run_in_local_repo(dir, repo, local_repo)
      @guide = GuideReader.new(dir, repo, log).read_guide!
    end

    def postprocess
      GuideCollection.upsert_by_slug(@guide.slug, @guide.as_json)
    end
  end
end