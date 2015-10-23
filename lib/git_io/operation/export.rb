module GitIo::Operation
  class Export < GitIo::Operation::Operation

    attr_accessor :guide, :bot

    def initialize(guide, bot)
      super(bot)
      @guide = guide
    end

    def repo
      @repo ||= GitIo::Repo.from_full_name(guide[:github_repository])
    end

    def run!
      Rails.logger.info "Exporting guide #{guide[:name]}"

      log = ExportLog.new
      log.with_error_logging do
        bot.ensure_exists! repo
        with_local_repo do |dir, local_repo|

          GuideWriter.new(dir, log).write_guide! guide

          local_repo.add(all: true)
          local_repo.commit("Mumuki Export on #{Time.now}")
          local_repo.push
        end
      end
    end
  end
end