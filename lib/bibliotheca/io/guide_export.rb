module Bibliotheca::IO
  class GuideExport < Bibliotheca::IO::Operation

    attr_accessor :guide, :bot, :author_email

    def initialize(options)
      super(options)
      @guide = options[:document]
      @author_email = options[:author_email]
    end

    def repo
      @repo ||= Mumukit::Service::Slug.from(guide.slug)
    end

    def before_run_in_local_repo
      bot.ensure_exists! repo
    end

    def run_in_local_repo(dir, local_repo)
      clear_repo local_repo
      GuideWriter.new(dir, log).write_guide! guide
      local_repo.add(all: true)
      local_repo.commit("Mumuki Export on #{Time.now}", commit_options)
      local_repo.push
    rescue Git::GitExecuteError => e
      puts "Could not export guide #{guide.slug} to git #{e}"
    end


    private

    def commit_options
      author_email.present? ? {author: "#{author_email} <#{author_email}>"} : {}
    end

    def clear_repo(local_repo)
      local_repo.remove %w(LICENSE.txt README.md COPYRIGHT.txt AUTHORS.txt description.md corollary.md meta.yml extra.yml expectations.* *_*/*)
    rescue Git::GitExecuteError => e
      puts 'Nothing to clean, repo seems to be empty'
    end
  end

  class OrganizationNotFoundError < StandardError
  end
end
