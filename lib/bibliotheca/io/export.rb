module Bibliotheca::IO
  class Export < Bibliotheca::IO::Operation

    attr_accessor :guide, :bot

    def initialize(guide, bot)
      super(bot)
      @guide = guide
    end

    def repo
      @repo ||= Bibliotheca::Repo.from_full_name(guide.slug)
    end

    def after_run_in_local_repo
      bot.ensure_exists! repo
    end

    def run_in_local_repo(dir, local_repo)
      GuideWriter.new(dir, log).write_guide! guide
      local_repo.add(all: true)
      local_repo.commit("Mumuki Export on #{Time.now}")
      local_repo.push
    rescue Git::GitExecuteError => e
      puts "Could not export guide #{guide.slug} to git #{e}"
    end
  end

  class OrganizationNotFoundError < StandardError
  end
end
