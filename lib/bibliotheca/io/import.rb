module Bibliotheca::IO
  class Import < Bibliotheca::IO::Operation
    attr_accessor :repo

    def initialize(bot, repo)
      super(bot)
      @repo = repo
    end

    def run_in_local_repo(dir, repo, local_repo)
      @guide = GuideReader.new(dir, repo, log).read_guide!
    end

    def postprocess
      Bibliotheca::Collection::Guides.upsert_by_slug(@guide.slug, @guide.as_json)
      Bibliotheca::IO::AtheneumExporter.run!(@guide.as_json)
    end
  end
end
