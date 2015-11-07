module GitIo::Operation
  class Import < GitIo::Operation::Operation
    def run_in_local_repo(dir, repo, local_repo)
      @guide = GuideReader.new(dir, repo, log).read_guide!
    end
  end
end