module Bibliotheca::IO
  class Operation
    attr_accessor :log, :bot

    def initialize(bot)
      @bot = bot
      @log = new_log
    end

    def with_local_repo
      Dir.mktmpdir("mumuki.#{self.class.name}") do |dir|
        local_repo = bot.clone_into repo, dir
        yield dir, local_repo
      end
    end

    def run!
      puts "#{self.class.name} : repository #{repo.full_name}"

      before_run_in_local_repo

      log.with_error_logging do
        with_local_repo do |dir, local_repo|
          run_in_local_repo dir, local_repo
        end
      end

      after_run_in_local_repo

      Bibliotheca::IO::AtheneumExporter.run!(guide)
    end

    def before_run_in_local_repo
    end

    def after_run_in_local_repo
    end

    def run_in_local_repo(dir, local_repo)
    end

    private

    def new_log
      Bibliotheca::IO::Log.new
    end
  end
end
