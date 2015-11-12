module GitIo::Operation
  class Import < GitIo::Operation::Operation
    def run_in_local_repo(dir, repo, local_repo)
      @guide = GuideReader.new(dir, repo, log).read_guide!
    end

    def postprocess
      GuideCollection.upsert_by_slug(@guide.github_repository, @guide.as_json)
    end
  end
end