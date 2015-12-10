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

    def run!
      bot.ensure_exists! repo
      with_local_repo do |dir, local_repo|

        GuideWriter.new(dir, log).write_guide! guide

        local_repo.add(all: true)
        local_repo.commit("Mumuki Export on #{Time.now}")
        local_repo.push
        Bibliotheca::IO::AtheneumExporter.new("http://central.localmumuki.io:3000/api/guides").run!(guide)
      end
    end
  end
end
