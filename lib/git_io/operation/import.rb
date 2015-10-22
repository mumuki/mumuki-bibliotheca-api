module GitIo::Operation
  class Import < GitIo::Operation::Operation
    def run_in_local_repo(dir, local_repo)
      @guide = GuideReader.new(dir, log).read!
    end
  end
end