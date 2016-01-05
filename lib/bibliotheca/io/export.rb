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

    def postprocess
      bot.ensure_exists! repo
      with_local_repo do |dir, local_repo|
        GuideWriter.new(dir, log).write_guide! guide
        local_repo.add(all: true)
        local_repo.commit("Mumuki Export on #{Time.now}")
        local_repo.push
      end
    rescue Git::GitExecuteError => e
      puts "Could not export guide #{guide.slug} to git #{e}"
    rescue Octokit::NotFound => e
      raise OrganizationNotFoundError.new("Organization #{repo.organization} does not exist")
    end
  end

  class OrganizationNotFoundError < StandardError
  end
end
