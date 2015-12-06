module Bibliotheca::IO
  class Operation
    attr_accessor :log, :bot

    def initialize(bot)
      @bot = bot
    end

    def with_local_repo
      Dir.mktmpdir("mumuki.#{self.class.name}") do |dir|
        local_repo = bot.clone_into repo, dir
        yield dir, local_repo
      end
    end

    def run!
      puts "#{self.class.name} : repository #{repo.full_name}"

      @log = new_log

      log.with_error_logging do
        with_local_repo do |dir, local_repo|
          run_in_local_repo dir, @repo, local_repo
        end
      end

      postprocess
    end

    def postprocess
    end

    private

    def new_log
      ImportLog.new
    end
  end
end